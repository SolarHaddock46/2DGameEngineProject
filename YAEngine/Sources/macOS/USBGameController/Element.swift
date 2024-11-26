//
//  CheckmarkSelectedView.swift
//  YAEngine
//

#if os(macOS)
import Foundation

extension USBGameController.Device {
    
    internal class Element {
        let properties: [String: AnyObject]
        let usage: Usage
        let subElements: [Element]

        var cookie: IOHIDElementCookie? {
            return (properties[kIOHIDElementCookieKey] as? NSNumber)?.uint32Value
        }

        var maxValue: Int {
            return (properties[kIOHIDElementMaxKey] as? NSNumber)?.intValue ?? 0
        }

        var minValue: Int {
            return (properties[kIOHIDElementMinKey] as? NSNumber)?.intValue ?? 0
        }
        
        var baseValue: Int {
            var half = Float((maxValue - minValue) / 2)
            half.round(.toNearestOrAwayFromZero)
            let result = Int(half)
            return result
        }
        
        var threshold: Int {
            return (maxValue - baseValue) / 2
        }

        init(properties: [String: AnyObject]) {
            self.properties = properties
            usage = Usage(properties: properties, variant: .element)

            let subElements = properties[kIOHIDElementKey] as? [[String: AnyObject]]
            self.subElements = subElements?.map { Element(properties: $0) } ?? []
        }
    }
}
#endif
