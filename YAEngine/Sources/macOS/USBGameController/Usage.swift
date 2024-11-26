//
//  Usage.swift
//  YAEngine
//

#if os(macOS)
import Foundation
import IOKit
import IOKit.hid

extension USBGameController.Device {
    internal struct Usage {
        
        enum Variant {
            case element
            case primary
            case device
        }
        
        let page: UInt
        let id: UInt

        init(properties: [String: AnyObject], variant: Variant) {
            switch variant {
            case .element:
                page = (properties[kIOHIDElementUsagePageKey] as? NSNumber)?.uintValue ?? 0
                id = (properties[kIOHIDElementUsageKey] as? NSNumber)?.uintValue ?? 0
            case .primary:
                page = (properties[kIOHIDPrimaryUsagePageKey] as? NSNumber)?.uintValue ?? 0
                id = (properties[kIOHIDPrimaryUsageKey] as? NSNumber)?.uintValue ?? 0
            case .device:
                page = (properties[kIOHIDDeviceUsagePageKey] as? NSNumber)?.uintValue ?? 0
                id = (properties[kIOHIDDeviceUsageKey] as? NSNumber)?.uintValue ?? 0
            }
        }
    }
}
#endif
