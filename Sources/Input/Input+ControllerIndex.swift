//
//  Input+ControllerIndex.swift
//  YAEngine
//

import Foundation
import GameController

extension Input {
    
    var nextAvailableGameControllerPlayerIndex: Int? {
        return availableControllerPlayerIndices.first
    }
    
    func consumeControllerPlayerIndex(playerIndex: Int) {
        if let idx = availableControllerPlayerIndices.firstIndex(of: playerIndex) {
            availableControllerPlayerIndices.remove(at: idx)
            connectedControllerPlayerIndices.append(playerIndex)
        }
    }
    
    func recollectGCControllerPlayerIndex(playerIndex: GCControllerPlayerIndex) {
        connectedGCControllerPlayerIndices[playerIndex] = nil
        availableGCControllerPlayerIndices.append(playerIndex)
        availableGCControllerPlayerIndices.sort { (leftIndex, rightIndex) -> Bool in
            leftIndex.rawValue < rightIndex.rawValue
        }
    }
    
    func recollectControllerPlayerIndex(playerIndex: Int) {
        if let idx = connectedControllerPlayerIndices.firstIndex(of: playerIndex) {
            connectedControllerPlayerIndices.remove(at: idx)
            availableControllerPlayerIndices.append(playerIndex)
            availableControllerPlayerIndices.sort()
        }
    }
    
}
