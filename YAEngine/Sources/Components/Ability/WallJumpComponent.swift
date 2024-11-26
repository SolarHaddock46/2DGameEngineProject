//
//  WallJumpComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that makes an entity gain horizontal and vertical velocity
/// from collision collider tiles which support wall jumping.
///
/// Required components:
/// - `KinematicsBodyComponent`
/// - `ColliderComponent`
public final class WallJumpComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 780
    
    /// `true` if there was jumping in the last frame.
    public private(set) var jumped: Bool = false
    
    /// Set to `true` to perform a jump given that the other conditions are met.
    /// If an entity has `PlayableCharacterComponent`, this property
    /// is automatically set for this component where needed.
    public var jumps: Bool = false
    
    /// `true` if the conditions are met for jumping.
    public var canJump: Bool {
        guard let collider = entity?.component(ofType: ColliderComponent.self) else {
            return false
        }
        return collider.pushesRightJumpWall || collider.pushesLeftJumpWall
    }
    
    // MARK: - Configuration
    
    public struct Configuration {
        public var wallJumpHorizontalVelocity: CGFloat = 10.0 // m/s²
        public var wallJumpVerticalVelocity: CGFloat = 22.0 // m/s²
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a wall jump component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = WallJumpComponent.sharedConfiguration) {
        self.configuration = configuration
        
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        performWallJumpIfNeeded()
    }
    
    // MARK: - Private
    
    private func performWallJumpIfNeeded() {
        guard
            let kinematicsBodyComponent = entity?.component(ofType: KinematicsBodyComponent.self),
            let colliderComponent = entity?.component(ofType: ColliderComponent.self)
            else {
                return
        }
        
        if jumps {
            
            colliderComponent.finishGroundContact()
            
            if colliderComponent.pushesLeftJumpWall {
                kinematicsBodyComponent.velocity.dx = abs(configuration.wallJumpHorizontalVelocity)
                kinematicsBodyComponent.velocity.dy = abs(configuration.wallJumpVerticalVelocity)
            } else if colliderComponent.pushesRightJumpWall {
                kinematicsBodyComponent.velocity.dx = -abs(configuration.wallJumpHorizontalVelocity)
                kinematicsBodyComponent.velocity.dy = abs(configuration.wallJumpVerticalVelocity)
            }
            
            kinematicsBodyComponent.resetMaximumVerticalVelocity()
        }
    }
}

extension WallJumpComponent: StateResettingComponent {
    public func resetStates() {
        jumped = jumps
        
        jumps = false
    }
}
