//
//  Stick.swift
//  YAEngine
//

#if os(macOS)
import Foundation

extension USBGameController.Device {
    internal class Stick {
        
        var xAxisElement: Element?
        var yAxisElement: Element?
        var stickElements: [Element] = []
        var povElements: [Element] = []

        var allElements: [Element] {
            return ([xAxisElement] + [yAxisElement] + stickElements + povElements).compactMap { $0 }
        }

        func attemptToAddElement(_ element: Element) -> Bool {
            guard element.usage.page == kHIDPage_GenericDesktop else {
                return false
            }

            switch Int(element.usage.id) {
            case kHIDUsage_GD_X:
                if xAxisElement == nil {
                    xAxisElement = element
                } else {
                    stickElements.append(element)
                }
            case kHIDUsage_GD_Y:
                if yAxisElement == nil {
                    yAxisElement = element
                } else {
                    stickElements.append(element)
                }
            case kHIDUsage_GD_Z,
                 kHIDUsage_GD_Rx,
                 kHIDUsage_GD_Ry,
                 kHIDUsage_GD_Rz:
                stickElements.append(element)
            case kHIDUsage_GD_Hatswitch:
                povElements.append(element)
            default:
                return false
            }
            return true
        }
    }
}
#endif
