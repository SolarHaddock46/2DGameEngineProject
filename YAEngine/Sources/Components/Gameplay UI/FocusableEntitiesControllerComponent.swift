//
//  FocusableEntitiesControllerComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that keeps track of a focused entity among a group of focusable
/// entities in a scene.
/// This component listens for default menu input profiles to switch between focusable
/// entities.
final class FocusableEntitiesControllerComponent: GKComponent, YAComponent {
    
    /// Call this function when the conversation is ready to proceed with the
    /// next speech.
    ///
    /// - Parameters:
    ///     - nextSpeech: Speech to proceed with. `nil` if the conversation has
    /// finished.
    public func focus(on focusable: FocusableComponent) {
        let focusables = scene?.entities.compactMap { $0.component(ofType: FocusableComponent.self) }
        guard focusables?.contains(focusable) == true else {
            return
        }
        
        if let focusedObject = focusables?.filter({ $0.isFocused }).first {
            focusedObject.isFocused = false
        }
        
        focusable.isFocused = true
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        updateFocusedEntity()
    }
    
    func willBeRemovedFromEntity() {
        prepareForReuse()
    }
    
    func entityWillBeRemovedFromScene() {
        prepareForReuse()
    }
    
    // MARK: - Private
    
    private var inputProfileCaptureTimes: [String: TimeInterval] = [:]
    
    private func isPressedOrHoldDown(profile: String, currentTime: TimeInterval) -> Bool {
        if Input.shared.isButtonPressed(profile) {
            return true
        }
        let result = Input.shared.isButtonHoldDown(profile)
        guard let lastPressTime = inputProfileCaptureTimes[profile] else {
            return result
        }
        
        return result && currentTime - lastPressTime > 0.5
    }
    
    private func updateFocusedEntity() {
        let focusables = scene?.entitiesSnapshot.compactMap { $0.component(ofType: FocusableComponent.self) }
        guard let focusedObject = focusables?.filter({ $0.isFocused }).first else {
            let firstResponder = focusables?.first{ $0.isFirstFocusable }
            if let firstResponder = firstResponder {
                firstResponder.isFocused = true
            } else {
                focusables?.first?.isFocused = true
            }
            return
        }
        
        guard let currentTime = currentTime else {
            return
        }
        
        if isPressedOrHoldDown(profile: "MenuLeft", currentTime: currentTime), let leftwardFocusable = focusedObject.leftwardFocusable {
            
            inputProfileCaptureTimes["MenuLeft"] = currentTime
            focusedObject.isFocused = false
            leftwardFocusable.isFocused = true
        } else if isPressedOrHoldDown(profile: "MenuRight", currentTime: currentTime), let rightwardFocusable = focusedObject.rightwardFocusable {
            
            inputProfileCaptureTimes["MenuRight"] = currentTime
            focusedObject.isFocused = false
            rightwardFocusable.isFocused = true
        } else if isPressedOrHoldDown(profile: "MenuUp", currentTime: currentTime), let upwardFocusable = focusedObject.upwardFocusable {
            
            inputProfileCaptureTimes["MenuUp"] = currentTime
            focusedObject.isFocused = false
            upwardFocusable.isFocused = true
        } else if isPressedOrHoldDown(profile: "MenuDown", currentTime: currentTime), let downwardFocusable = focusedObject.downwardFocusable {
            
            inputProfileCaptureTimes["MenuDown"] = currentTime
            focusedObject.isFocused = false
            downwardFocusable.isFocused = true
        } else if Input.shared.isButtonPressed(focusedObject.selectionInputProfile) {
            focusedObject.isSelected = true
        } else if Input.shared.isButtonPressed("Cancel") {
            focusedObject.isCancelled = true
        }
    }
    
    private func prepareForReuse() {
        inputProfileCaptureTimes = [:]
    }
}
