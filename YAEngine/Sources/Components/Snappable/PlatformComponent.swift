//
//  PlatformComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that provides snapping behaviors of a platform.
public final class PlatformComponent: GKComponent, GlideComponent {
    
    /// `true` if the component's entity is affected by gravity.
    /// Entity should have a `KinematicsBodyComponent` for this to work.
    public var isGravityEnabled: Bool = false
    
    public override func update(deltaTime seconds: TimeInterval) {
        guard let kinematicsBodyComponent = (entity?.component(ofType: KinematicsBodyComponent.self)) else {
            return
        }
        if isGravityEnabled == false {
            kinematicsBodyComponent.gravityInEffect = 0
        }
    }
    
    public func handleNewCollision(_ contact: Contact) {
        handleSnapping(with: contact)
    }
    
    public func handleExistingCollision(_ contact: Contact) {
        handleSnapping(with: contact)
    }
    
    // MARK: - Private
    
    private func handleSnapping(with contact: Contact) {
        let otherEntity = contact.otherObject.colliderComponent?.entity
        guard let snapper = otherEntity?.component(ofType: SnapperComponent.self) else {
            return
        }
        
        if contact.otherContactSides?.contains(.bottom) == true {
            snapper.isSnapping = true
            snapper.snappedPositionCallback = { [weak self] transform in
                guard let self = self else { return nil }
                guard let selfTransform = self.transform else { return nil }
                return CGPoint(x: transform.proposedPosition.x + selfTransform.currentTranslation.dx,
                               y: transform.proposedPosition.y + selfTransform.currentTranslation.dy)
            }
        }
    }
}
