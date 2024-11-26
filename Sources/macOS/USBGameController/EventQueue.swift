//
//  EventQueue.swift
//  YAEngine
//

#if os(macOS)
import CoreFoundation
import Dispatch
import Foundation
import IOKit

internal protocol USBGameControllerEventQueueDelegate: AnyObject {
    func queueDidReceiveEvents(_ queue: USBGameController.Device.EventQueue)
}

extension USBGameController.Device {
    
    internal class EventQueue {
        
        weak var delegate: USBGameControllerEventQueueDelegate?
        
        var nextEvent: Event? {
            var event = IOHIDEventStruct()
            // This is required because "AbsoluteTime" is currently not
            // defined for swift.
            let absoluteTime = type(of: event.timestamp)
            let zeroTime = absoluteTime.init(lo: 0, hi: 0)

            _ = hidQueue.pointee?.pointee.getNextEvent(hidQueue, &event, zeroTime, UInt32(0))

            return Event(event)
        }

        init?(hidQueue: UnsafeMutablePointer<UnsafeMutablePointer<IOHIDQueueInterface>?>, size: UInt32) {
            self.hidQueue = hidQueue
            
            let result = hidQueue.pointee?.pointee.create(hidQueue, 0, size)
            if result != kIOReturnSuccess {
                return nil
            }
        }

        func startOnCurrentRunLoop() {
            startOnRunLoop(RunLoop.current)
        }
        
        func stop() {
            if isStarted {
                return
            }

            CFRunLoopRemoveSource(runLoop?.getCFRunLoop(), eventSource?.takeUnretainedValue(), CFRunLoopMode.defaultMode)
            hidQueue.pointee?.pointee.setEventCallout = nil
            _ = hidQueue.pointee?.pointee.stop(hidQueue)

            runLoop = nil
            eventSource = nil
            isStarted = false
        }
        
        func addElements(_ elements: [Element], recursively: Bool = false) {
            elements.forEach {
                self.addElement($0)
                if recursively {
                    self.addElements($0.subElements)
                }
            }
        }
        
        // MARK: - Private

        private let hidQueue: UnsafeMutablePointer<UnsafeMutablePointer<IOHIDQueueInterface>?>
        private var runLoop: RunLoop?
        private var isStarted: Bool = false
        private var eventSource: Unmanaged<CFRunLoopSource>?
        
        private func startOnRunLoop(_ runLoop: RunLoop) {
            guard isStarted == false else {
                return
            }

            self.runLoop = runLoop

            _ = hidQueue.pointee?.pointee.createAsyncEventSource(hidQueue, &eventSource)

            let callBack: IOHIDCallbackFunction = { (target: UnsafeMutableRawPointer?, _: IOReturn, _: UnsafeMutableRawPointer?, _: UnsafeMutableRawPointer?) -> Void in

                let queue = unsafeBitCast(target, to: EventQueue.self)
                queue.delegate?.queueDidReceiveEvents(queue)
            }

            let selfRef = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)
            _ = hidQueue.pointee?.pointee.setEventCallout(hidQueue, callBack, selfRef, nil)

            CFRunLoopAddSource(runLoop.getCFRunLoop(), eventSource?.takeUnretainedValue(), CFRunLoopMode.defaultMode)
            _ = hidQueue.pointee?.pointee.start(hidQueue)
            isStarted = true
        }

        private func addElement(_ element: Element) {
            guard let cookie = element.cookie else {
                return
            }
            _ = hidQueue.pointee?.pointee.addElement(hidQueue, cookie, 0)
        }

        deinit {
            stop()
            _ = hidQueue.pointee?.pointee.dispose(hidQueue)
            _ = hidQueue.pointee?.pointee.Release(hidQueue)
        }
    }
}
#endif
