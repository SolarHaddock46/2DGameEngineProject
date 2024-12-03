//
//  JumpComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that makes an entity gain a momentary vertical speed while on ground.
///
/// Required components:
/// - `KinematicsBodyComponent`
/// - `ColliderComponent`
public final class JumpComponent: GKComponent, YAComponent {
    
    public static let componentPriority: Int = 790
    
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
        let isSnapping = entity?.component(ofType: SnapperComponent.self)?.isSnapping == true
        let canJumpFromCorner = configuration.isCornerJumpsEnabled && collider.onCornerJump
        let onGround = collider.onGround || collider.onSlope || canJumpFromCorner || isSnapping
        return onGround
    }
    
    // MARK: - Configuration
    
    public struct Configuration {
        public var jumpingVelocity: CGFloat = 13.0 // m/s
        public var fasterVerticalVelocityDiff: CGFloat = 1.0 // m/s
        public var serialJumpThreshold: TimeInterval = 0.2 // s
        public var isCornerJumpsEnabled: Bool = true
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a jump component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = JumpComponent.sharedConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        performJumpIfNeeded()
    }
    
    // MARK: - Private
    
    private func performJumpIfNeeded() {
        guard
            let kinematicsBody = entity?.component(ofType: KinematicsBodyComponent.self),
            let collider = entity?.component(ofType: ColliderComponent.self)
            else {
                return
        }
        
        guard jumped == false && jumps else {
            return
        }
        
        collider.finishGroundContact()
        
        kinematicsBody.velocity.dy = configuration.jumpingVelocity
        if abs(kinematicsBody.velocity.dx) > 0 {
            kinematicsBody.velocity.dy += configuration.fasterVerticalVelocityDiff
        }
    }
}

extension JumpComponent: StateResettingComponent {
    public func resetStates() {
        jumped = jumps
        
        jumps = false
    }
}
