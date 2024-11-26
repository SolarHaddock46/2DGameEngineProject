//
//  Event.swift
//  YAEngine
//

#if os(macOS)
import IOKit

extension USBGameController.Device.EventQueue {
    internal class Event {
        
        let hidEvent: IOHIDEventStruct
        
        var elementCookie: IOHIDElementCookie {
            return hidEvent.elementCookie
        }
        
        var value: Int32 {
            return hidEvent.value
        }
        
        init?(_ hidEvent: IOHIDEventStruct) {
            guard hidEvent.elementCookie != 0 else {
                return nil
            }
            self.hidEvent = hidEvent
        }
    }
}
#endif
