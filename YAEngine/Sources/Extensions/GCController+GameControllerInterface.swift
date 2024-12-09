//
//  GCController+GameControllerInterface.swift
//  YAEngine
//

import GameController

extension GCController: GameControllerInterface {
    var playerIdx: Int? {
        get {
            return Input.shared.connectedGCControllerPlayerIndices[playerIndex]
        }
        set {
            if let nextAvailableGCControllerPlayerIndex = Input.shared.availableGCControllerPlayerIndices.first {
                playerIndex = nextAvailableGCControllerPlayerIndex
                
                Input.shared.connectedGCControllerPlayerIndices[playerIndex] = newValue
                Input.shared.availableGCControllerPlayerIndices.remove(at: 0)
            }
        }
    }
}

extension GCExtendedGamepad: ExtendedGamepadInterface {}
extension GCMicroGamepad: MicroGamepadInterface {}
extension GCControllerButtonInput: GamepadButtonInterface {}
extension GCControllerDirectionPad: GamepadDirectionPadInterface {}
