//
//  SnappableComponent.swift
//  YAEngine
//

import GameplayKit

/// Snapping is a special behavior which helps with establishing collisions between moving
/// objects. Add this component to your entity to make other objects with `SnapperComponent`
/// collide with it or snap on it. Specific snapping behavior for your entity should be
/// implemented in your custom components. For an example of this see `PlatformComponent`.
/// An entity with Snappable component always gets updated before other custom entities.
public final class SnappableComponent: GKComponent, GlideComponent {
    
    /// `true` if the entity behaves as a one way collider on collisions with
    /// other entities, that is they only collide with their bottom side over
    /// top side of this entity.
    public let providesOneWayCollision: Bool
    
    // MARK: - Initialize
    
    /// Create a snappable component.
    ///
    /// - Parameters:
    ///     - providesOneWayCollision: `true` if the entity behaves as a one way collider on
    /// collisions.
    public init(providesOneWayCollision: Bool) {
        self.providesOneWayCollision = providesOneWayCollision
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
