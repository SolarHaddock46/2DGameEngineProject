//
//  BouncingPlatformComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that makes an entity bounce other entities upwards that touch it
/// from above.
///
/// `PlatformComponent` is still required for the entity to carry the properties
/// of a platform if that is desired.
/// Entity which is actually bouncing should have a `KinematicsBodyComponent`.
public final class BouncingPlatformComponent: GKComponent, GlideComponent {
    
    // MARK: - Configuration
    
    public struct Configuration {
        /// Value that will be added to bouncing entity's `KinematicsBodyComponent`
        /// vertical velocity.
        public var bouncingVelocity: CGFloat = 50.0 // m/s
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a bouncing platform component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = BouncingPlatformComponent.sharedConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func handleNewCollision(_ collision: Contact) {
        bounceIfNeeded(collision)
    }
    
    public func handleExistingCollision(_ collision: Contact) {
        bounceIfNeeded(collision)
    }
    
    // MARK: - Private
    
    private func bounceIfNeeded(_ collision: Contact) {
        let other = collision.otherObject.colliderComponent?.entity
        if collision.otherContactSides?.contains(.bottom) == true {
            other?.component(ofType: KinematicsBodyComponent.self)?.velocity.dy += configuration.bouncingVelocity
        }
    }
}
