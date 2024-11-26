//
//  FallingPlatformComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that makes an entity fall off via gravity after a specified
/// time getting touched by another entity from above.
///
/// `PlatformComponent` is required for this component to work with gravity.
public final class FallingPlatformComponent: GKComponent, GlideComponent, RespawnableEntityComponent {
    
    // MARK: - RespawnableEntityComponent
    public var respawnedEntity: ((_ numberOfRespawnsLeft: Int) -> GlideEntity)?
    public internal(set) var numberOfRespawnsLeft = Int.max
    
    // MARK: - Configuration
    
    public struct Configuration {
        /// Velocity that will be set to bouncing entity's `KinematicsBodyComponent`.
        public var delayToFallAfterTouch: TimeInterval = 0.5 // seconds
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a falling platform component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = FallingPlatformComponent.sharedConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        if isWaitingToFall {
            timer += seconds
            if timer >= configuration.delayToFallAfterTouch {
                entity?.component(ofType: PlatformComponent.self)?.isGravityEnabled = true
                entity?.component(ofType: ColliderComponent.self)?.isEnabled = false
            }
        } else if didGetContact == true {
            isWaitingToFall = true
        }
    }
    
    public func handleNewCollision(_ collision: Contact) {
        provideContactIfNeeded(collision)
    }
    
    public func handleExistingCollision(_ collision: Contact) {
        provideContactIfNeeded(collision)
    }
    
    // MARK: - Private
    
    private var timer: TimeInterval = 0.0
    private var isWaitingToFall: Bool = false
    private var didGetContact: Bool = false
    private var getsContact: Bool = false
    
    private func provideContactIfNeeded(_ collision: Contact) {
        if collision.otherContactSides?.contains(.bottom) == true {
            getsContact = true
        }
    }
    
}

extension FallingPlatformComponent: StateResettingComponent {
    public func resetStates() {
        didGetContact = getsContact
        getsContact = false
    }
}

extension FallingPlatformComponent: RemovalControllingComponent {
    public var canEntityBeRemoved: Bool {
        return entity?.component(ofType: ColliderComponent.self)?.isOutsideCollisionMapBounds ?? false
    }
}
