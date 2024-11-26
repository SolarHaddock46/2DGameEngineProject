//
//  CustomGameControllerObserver.swift
//  YAEngine
//

#if os(macOS)
import Foundation

internal class USBGameControllerObserver {
    let managerRef = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))

    var didUpdateControllersHandler: (([USBGameController.Device]) -> Void)?

    init() {
        let deviceMatches: [[String: Any]] = [
            [kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop, kIOHIDDeviceUsageKey: kHIDUsage_GD_Joystick],
            [kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop, kIOHIDDeviceUsageKey: kHIDUsage_GD_GamePad],
            [kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop, kIOHIDDeviceUsageKey: kHIDUsage_GD_MultiAxisController]
        ]

        IOHIDManagerSetDeviceMatchingMultiple(managerRef, deviceMatches as CFArray)
        IOHIDManagerScheduleWithRunLoop(managerRef, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
        IOHIDManagerOpen(managerRef, IOOptionBits(kIOHIDOptionsTypeNone))

        let matchingCallback: IOHIDDeviceCallback = { inContext, _, _, inIOHIDDeviceRef in
            let this: USBGameControllerObserver = unsafeBitCast(inContext, to: USBGameControllerObserver.self)
            this.didUpdateControllersHandler?(this.connectedControllers)
        }

        let removalCallback: IOHIDDeviceCallback = { inContext, _, _, _ in
            let this: USBGameControllerObserver = unsafeBitCast(inContext, to: USBGameControllerObserver.self)
            this.didUpdateControllersHandler?(this.connectedControllers)
        }

        IOHIDManagerRegisterDeviceMatchingCallback(managerRef, matchingCallback, unsafeBitCast(self, to: UnsafeMutableRawPointer.self))
        IOHIDManagerRegisterDeviceRemovalCallback(managerRef, removalCallback, unsafeBitCast(self, to: UnsafeMutableRawPointer.self))
    }

    var connectedControllers: [USBGameController.Device] {
        let allGamePads = allDevicesMatching(usagePage: kHIDPage_GenericDesktop,
                                             usageId: kHIDUsage_GD_GamePad,
                                             skipZeroLocations: true)
        let allJoysticks = allDevicesMatching(usagePage: kHIDPage_GenericDesktop,
                                              usageId: kHIDUsage_GD_Joystick,
                                              skipZeroLocations: true)
        let allMultiAxisControllers = allDevicesMatching(usagePage: kHIDPage_GenericDesktop,
                                                         usageId: kHIDUsage_GD_MultiAxisController,
                                                         skipZeroLocations: true)
        var all = (allGamePads ?? []) + (allJoysticks ?? []) + (allMultiAxisControllers ?? [])
        all.sort { (leftDevice, rightDevice) -> Bool in
            let leftLocationId = leftDevice.locationId ?? 0
            let rightLocationId = rightDevice.locationId ?? 0

            return leftLocationId < rightLocationId
        }

        return all
    }

    func allDevicesMatching(usagePage: Int, usageId: Int, skipZeroLocations: Bool) -> [USBGameController.Device]? {
        guard let dictionary = IOServiceMatching(kIOHIDDeviceKey) else {
            return nil
        }

        (dictionary as NSMutableDictionary).setValue(usagePage, forKey: kIOHIDDeviceUsagePageKey)
        (dictionary as NSMutableDictionary).setValue(usageId, forKey: kIOHIDDeviceUsageKey)

        return createDevicesWith(dictionary: dictionary, skipZeroLocations: false)
    }

    func createDevicesWith(dictionary: CFMutableDictionary, skipZeroLocations: Bool) -> [USBGameController.Device]? {
        var hidObjectIterator = io_iterator_t(MACH_PORT_NULL)
        let result = IOServiceGetMatchingServices(kIOMasterPortDefault, dictionary, &hidObjectIterator)
        if result != kIOReturnSuccess {
            return nil
        }

        guard hidObjectIterator > 0 else {
            return nil
        }

        var allDevices: [USBGameController.Device] = []
        while case let hidDevice = IOIteratorNext(hidObjectIterator), hidDevice != 0 {
            if let devices = self.devices(for: hidDevice, skipZeroLocations: skipZeroLocations) {
                allDevices.append(contentsOf: devices)
            }
        }
        if hidObjectIterator != MACH_PORT_NULL {
            IOObjectRelease(hidObjectIterator)
        }

        return allDevices
    }

    func devices(for hidDevice: io_object_t, skipZeroLocations: Bool) -> [USBGameController.Device]? {
        guard let device = USBGameController.Device(device: hidDevice, logicalDeviceNumber: 0) else {
            return nil
        }
        if device.locationId == 0 && skipZeroLocations {
            return nil
        }

        var result = [device]

        for index in device.logicalDeviceElements.indices {
            if let device = USBGameController.Device(device: hidDevice, logicalDeviceNumber: index + 1) {
                result.append(device)
            }
        }

        return result
    }
}
#endif
