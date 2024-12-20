//
//  TouchReceiverComponent.swift
//  YAEngine
//

#if os(iOS)
import SpriteKit
import GameplayKit

/// When adopted, component's entity will be able to manage touch inputs
/// on an iOS device.
public protocol TouchReceiverComponent: AnyObject {
    
    /// Node for testing the hits of touches from the screen.
    /// This should be a node with a non empty parent.
    var hitBoxNode: SKSpriteNode { get }
    
    /// Value to keep track of current touch count.
    /// Don't set this value directly.
    var currentTouchCount: Int { get set }
    
    /// Value to keep track of the highlighted state as a result of
    /// touch inputs.
    /// Don't set this value directly.
    var isHighlighted: Bool { get set }
    
    /// `true` if the component will register input events when the
    /// touches are ended inside the hit box node of the component.
    var triggersOnTouchUpInside: Bool { get }
    
    /// Input value to register when a touch event is captured for the component.
    var input: TouchInputProfilesOrCallback { get }
}

extension TouchReceiverComponent where Self: YAComponent & GKComponent {
    
    func touchesBegan(_ touches: Set<UITouch>) {
        guard let view = scene?.view else {
            return
        }
        
        for touch in touches {
            let locationInView = touch.location(in: view)
            processTouchesBegan(for: locationInView)
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>) {
        guard let view = scene?.view else {
            return
        }
        
        for touch in touches {
            let locationInView = touch.location(in: view)
            let previousLocationInView = touch.previousLocation(in: view)
            processTouchesMoved(for: locationInView,
                                previousTouchLocation: previousLocationInView)
        }
    }
    
    func touchesEnded(_ touches: Set<UITouch>, isCancelled: Bool) {
        guard let view = scene?.view else {
            return
        }
        
        for touch in touches {
            let previousLocationInView = touch.previousLocation(in: view)
            processTouchesEnded(for: previousLocationInView,
                                isCancelled: isCancelled)
        }
    }
    
    // MARK: - Private
    
    private func doesNodeContainTouchLocation(_ touchLocation: CGPoint) -> Bool {
        guard let scene = scene else {
            return false
        }
        
        guard let parent = hitBoxNode.parent else {
            return false
        }
        
        var convertedOrigin = parent.convert(hitBoxNode.position, to: scene)
        convertedOrigin = scene.convertPoint(toView: convertedOrigin)
        let convertedFrame = convertedOrigin.centeredFrame(withSize: hitBoxNode.size)
        
        return convertedFrame.contains(touchLocation)
    }
    
    private func processTouchesBegan(for touchLocation: CGPoint) {
        if doesNodeContainTouchLocation(touchLocation) {
            currentTouchCount += 1
            didRecognize()
        }
    }
    
    private func processTouchesMoved(for touchLocation: CGPoint,
                                     previousTouchLocation: CGPoint) {
        
        let nodeContainsLocation = doesNodeContainTouchLocation(touchLocation)
        let nodeContainsPreviousLocation = doesNodeContainTouchLocation(previousTouchLocation)
        
        if nodeContainsLocation == false && nodeContainsPreviousLocation == true {
            currentTouchCount = max(currentTouchCount - 1, 0)
            if currentTouchCount == 0 {
                didRelease(isCancelled: true)
            }
        } else if nodeContainsLocation == true && nodeContainsPreviousLocation == false {
            currentTouchCount += 1
            didRecognize()
        }
    }
    
    private func processTouchesEnded(for previousTouchLocation: CGPoint,
                                     isCancelled: Bool) {
        if doesNodeContainTouchLocation(previousTouchLocation) {
            currentTouchCount = max(currentTouchCount - 1, 0)
            if currentTouchCount == 0 {
                didRelease(isCancelled: isCancelled)
            }
        }
    }
    
    private func didRecognize() {
        
        isHighlighted = true
        
        if let focusable = entity?.component(ofType: FocusableComponent.self) {
            scene?.focusableEntitiesControllerEntity.component(ofType: FocusableEntitiesControllerComponent.self)?.focus(on: focusable)
        }
        
        guard triggersOnTouchUpInside == false else {
            return
        }
        
        switch input {
        case let .profiles(profiles):
            for profile in profiles {
                let profileName = profile.name
                let isNegative = profile.isNegative
                if isNegative {
                    Input.shared.addKey(.touchNegative, profileName: profileName)
                } else {
                    Input.shared.addKey(.touchPositive, profileName: profileName)
                }
            }
        case let .callback(handler):
            handler()
        }
    }
    
    private func didRelease(isCancelled: Bool) {
        isHighlighted = false
        
        if triggersOnTouchUpInside && isCancelled == false {
            switch input {
            case let .profiles(profiles):
                for profile in profiles {
                    let profileName = profile.name
                    let isNegative = profile.isNegative
                    if isNegative {
                        Input.shared.addKey(.touchNegative, profileName: profileName, removeAtNextUpdate: true)
                    } else {
                        Input.shared.addKey(.touchPositive, profileName: profileName, removeAtNextUpdate: true)
                    }
                }
            case let .callback(handler):
                handler()
            }
        } else {
            switch input {
            case let .profiles(profiles):
                for profile in profiles {
                    let profileName = profile.name
                    let isNegative = profile.isNegative
                    if isNegative {
                        Input.shared.removeKey(.touchNegative, profileName: profileName)
                    } else {
                        Input.shared.removeKey(.touchPositive, profileName: profileName)
                    }
                }
            default:
                break
            }
        }
    }
}
#endif
