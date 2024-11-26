//
//  CroucherComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that gives an entity the ability to ignore one way grounds while
/// its entity is above them and pass through below the ground.
/// This component is also used by `PlayableCharacterComponent` which makes
/// it possible to react to crouching via assigning a custom texture animation.
public final class CroucherComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 670
    
    /// `true` if the entity was crouching in the last frame.
    public private(set) var didCrouch: Bool = false
    
    /// `true` if the entity is crouching in the current frame.
    public var crouches: Bool = false
    
    public override func update(deltaTime seconds: TimeInterval) {
        if crouches {
            entity?.component(ofType: ColliderComponent.self)?.pushesDown = true
            transform?.proposedPosition = (transform?.currentPosition ?? .zero) - CGPoint(x: 0, y: 1)
        }
    }
}

extension CroucherComponent: StateResettingComponent {
    public func resetStates() {
        didCrouch = crouches
        crouches = false
    }
}
