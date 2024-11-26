//
//  GameControllerInterface.swift
//  YAEngine
//

import Foundation

protocol GameControllerInterface: AnyObject {
    associatedtype ExtendedGamepad: ExtendedGamepadInterface
    associatedtype MicroGamepad: MicroGamepadInterface

    var playerIdx: Int? { get set }
    var extendedGamepad: ExtendedGamepad? { get }
    var microGamepad: MicroGamepad? { get }
}

protocol MicroGamepadInterface {}

protocol ExtendedGamepadInterface {
    associatedtype Button: GamepadButtonInterface
    associatedtype DirectionPad: GamepadDirectionPadInterface
    
    var buttonA: Button { get }
    var buttonB: Button { get }
    var buttonY: Button { get }
    var buttonX: Button { get }
    var dpad: DirectionPad { get }
    var leftThumbstick: DirectionPad { get }
    var rightThumbstick: DirectionPad { get }
    var leftShoulder: Button { get }
    var rightShoulder: Button { get }
    var leftTrigger: Button { get }
    var rightTrigger: Button { get }
    var buttonMenu: Button { get }
}

protocol GamepadButtonInterface: AnyObject {
    associatedtype Button

    var pressedChangedHandler: ((Button, Float, Bool) -> Void)? { get set }
}

protocol GamepadDirectionPadInterface: AnyObject {
    associatedtype DirectionPad

    var valueChangedHandler: ((DirectionPad, Float, Float) -> Void)? { get set }
}
