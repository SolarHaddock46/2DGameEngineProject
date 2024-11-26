//
//  WallClingerComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that makes an entity be effected by a lower gravity and have a lower vertical
/// speed while contacting collision collider tiles which support wall jumping.
///
/// Required components:
/// - `KinematicsBodyComponent`
/// - `ColliderComponent`
public final class WallClingerComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 770
    
    /// `true` if there was clinging in the last frame.
    public private(set) var wasClinging: Bool = false
    
    /// `true` if the component is currently clinging. Value of this property is
    /// internally managed if the clinging conditions are met.
    /// Basic conditions are:
    /// - Collider is contacting a jump wall
    /// - Collider is on air
    /// - Collider's vertical velocity is a negative value
    public private(set) var isClinging: Bool = false
    
    // MARK: - Configuration
    
    public struct Configuration {
        /// Gravity value to apply while this component's entity is clinging to a wall.
        public var gravity: CGFloat = 15.0 // m/s²
        /// Maximum vertical velocity this component's entity can have during wall clinging.
        public var maximumVerticalVelocity: CGFloat = 5.0 // m/s
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a wall clinger component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = WallClingerComponent.sharedConfiguration) {
        self.configuration = configuration
        
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        performClingingIfNeeded()
    }
    
    // MARK: - Private
    
    private func performClingingIfNeeded() {
        guard
            let kinematicsBody = entity?.component(ofType: KinematicsBodyComponent.self),
            let collider = entity?.component(ofType: ColliderComponent.self)
            else {
                return
        }
        
        let paragliderComponent = entity?.component(ofType: ParagliderComponent.self)
        let isParagliding = paragliderComponent?.isParagliding == true
        
        if (collider.pushesLeftJumpWall ||
            collider.pushesRightJumpWall) &&
            collider.isOnAir == true &&
            kinematicsBody.velocity.dy < 0 &&
            isParagliding == false {
            
            isClinging = true
            kinematicsBody.gravityInEffect = configuration.gravity
            kinematicsBody.currentMaximumVerticalVelocity = configuration.maximumVerticalVelocity
        }
    }
}

extension WallClingerComponent: StateResettingComponent {
    public func resetStates() {
        wasClinging = isClinging
        isClinging = false
    }
}
