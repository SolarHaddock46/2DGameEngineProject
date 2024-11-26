//
//  USBGameController+GameControllerInterface.swift
//  YAEngine
//

#if os(macOS)
import Foundation

extension USBGameController: GameControllerInterface {}

class USBExtendedGamepad: ExtendedGamepadInterface {

    var buttonA = USBGameControllerButton()
    var buttonB = USBGameControllerButton()
    var buttonY = USBGameControllerButton()
    var buttonX = USBGameControllerButton()
    var dpad = USBGameControllerDirectionPad()
    var leftThumbstick = USBGameControllerDirectionPad()
    var rightThumbstick = USBGameControllerDirectionPad()
    var leftShoulder = USBGameControllerButton()
    var rightShoulder = USBGameControllerButton()
    var leftTrigger = USBGameControllerButton()
    var rightTrigger = USBGameControllerButton()
    var buttonMenu = USBGameControllerButton()
}

class USBMicroGamepad: MicroGamepadInterface {
    var buttonA = USBGameControllerButton()
    var buttonX = USBGameControllerButton()
    var dpad = USBGameControllerDirectionPad()
}

class USBGameControllerButton: GamepadButtonInterface {
    var pressedChangedHandler: ((USBGameControllerButton, Float, Bool) -> Void)?
}

class USBGameControllerDirectionPad: GamepadDirectionPadInterface {
    var valueChangedHandler: ((USBGameControllerDirectionPad, Float, Float) -> Void)?
    var x: Float = 0
    var y: Float = 0
    
    var rawX: Int = 0
    var rawY: Int = 0
}
#endif
