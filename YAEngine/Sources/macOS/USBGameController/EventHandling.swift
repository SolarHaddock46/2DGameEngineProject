//
//  EventHandling.swift
//  YAEngine
//

#if os(macOS)
import IOKit

internal protocol USBGameControllerDeviceDelegate: AnyObject {
    func deviceXAxisStickValueChanged(_ device: USBGameController.Device, value: Int, baseValue: Int, threshold: Int, stickIndex: Int)
    func deviceYAxisStickValueChanged(_ device: USBGameController.Device, value: Int, baseValue: Int, threshold: Int, stickIndex: Int)
    func deviceOtherAxisStickValueChanged(_ device: USBGameController.Device, value: Int, baseValue: Int, threshold: Int, stickIndex: Int, otherAxisIndex: Int)
    func devicePovAxisStickValueChanged(_ device: USBGameController.Device, value: Int, stickIndex: Int, povNumber: Int)
    
    func deviceDidPressButton(_ device: USBGameController.Device, buttonIndex: Int)
    func deviceDidReleaseButton(_ device: USBGameController.Device, buttonIndex: Int)
}

extension USBGameController.Device: USBGameControllerEventQueueDelegate {
    
    func queueDidReceiveEvents(_ queue: EventQueue) {
        while case let e = queue.nextEvent, let event = e {
            parseValueFromEvent(event)
        }
    }
    
    // swiftlint:disable:next function_body_length
    private func parseValueFromEvent(_ event: EventQueue.Event) {
        let cookie = event.elementCookie
        let value = event.value

        if let xAxisStick = stickForXAxis(withCookie: cookie) {
            delegate?.deviceXAxisStickValueChanged(
                self,
                value: Int(value),
                baseValue: xAxisStick.element.baseValue,
                threshold: xAxisStick.element.threshold,
                stickIndex: xAxisStick.stickIndex)
        } else if let yAxisStick = stickForYAxis(withCookie: cookie) {
            delegate?.deviceYAxisStickValueChanged(
                self,
                value: Int(value),
                baseValue: yAxisStick.element.baseValue,
                threshold: yAxisStick.element.threshold,
                stickIndex: yAxisStick.stickIndex)
        } else if let otherAxisStick = stickForOtherAxis(withCookie: cookie) {
            delegate?.deviceOtherAxisStickValueChanged(
                self,
                value: Int(value),
                baseValue: otherAxisStick.element.baseValue,
                threshold: otherAxisStick.element.threshold,
                stickIndex: otherAxisStick.stickIndex,
                otherAxisIndex: otherAxisStick.axis)
        } else if let povStick = stickForPOVNumber(withCookie: cookie) {
            delegate?.devicePovAxisStickValueChanged(
                self,
                value: Int(value),
                stickIndex: povStick.stickIndex,
                povNumber: povStick.povNumber)
        } else {
            let buttonIndex = buttons.firstIndex { cookie == $0.cookie } ?? 0

            if value == 1 {
                delegate?.deviceDidPressButton(self, buttonIndex: buttonIndex)
            } else if value == 0 {
                delegate?.deviceDidReleaseButton(self, buttonIndex: buttonIndex)
            } else {
                #if DEBUG
                if let element = elementsByCookie[UInt(event.elementCookie)] {
                    print("Element that received value can not be found: \(element)")
                }
                #endif
            }
        }
    }

    private func stickForXAxis(withCookie cookie: IOHIDElementCookie) -> (stickIndex: Int, element: Element)? {
        for (index, stick) in sticks.enumerated() {
            if let xAxisElement = stick.xAxisElement, xAxisElement.cookie == cookie {
                return (stickIndex: index, element: xAxisElement)
            }
        }
        return nil
    }

    private func stickForYAxis(withCookie cookie: IOHIDElementCookie) -> (stickIndex: Int, element: Element)? {
        for (index, stick) in sticks.enumerated() {
            if let yAxisElement = stick.yAxisElement, yAxisElement.cookie == cookie {
                return (stickIndex: index, element: yAxisElement)
            }
        }
        return nil
    }
    
    private struct StickContext {
        let stickIndex: Int
        let element: Element
        let axis: Int
    }
    
    private struct POVContext {
        let stickIndex: Int
        let element: Element
        let povNumber: Int
    }

    private func stickForOtherAxis(withCookie cookie: IOHIDElementCookie) -> StickContext? {
        for (index, stick) in sticks.enumerated() {
            for (stickElementIndex, stickElement) in stick.stickElements.enumerated() where stickElement.cookie == cookie {
                return StickContext(stickIndex: index, element: stickElement, axis: stickElementIndex)
            }
        }
        return nil
    }

    private func stickForPOVNumber(withCookie cookie: IOHIDElementCookie) -> POVContext? {
        for (index, stick) in sticks.enumerated() {
            for (povElementIndex, povElement) in stick.povElements.enumerated() where povElement.cookie == cookie {
                return POVContext(stickIndex: index, element: povElement, povNumber: povElementIndex)
            }
        }
        return nil
    }
}
#endif
