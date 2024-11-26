//
//  ParagliderComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that makes an entity be affected by a lower gravity while it is
/// falling down on air.
///
/// Required components:
/// - `KinematicsBodyComponent`
/// - `ColliderComponent`
public final class ParagliderComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 750
    
    /// `true` if there was paragliding in the last frame.
    public private(set) var wasParagliding: Bool = true
    
    /// Set to `true` to perform paragliding given that the other conditions are met.
    /// If an entity has `PlayableCharacterComponent`, this property
    /// is automatically set for this component where needed.
    public internal(set) var isParagliding: Bool = false
    
    /// `true` if paragliding can be triggered more than once while on the air.
    public private(set) var canMultiParaglide: Bool = true
    
    /// `true` if the conditions are met for jumping.
    public private(set) var canParaglide: Bool = false
    
    // MARK: - Configuration
    
    public struct Configuration {
        public var gravity: CGFloat = 5 // m/s²
        /// Maximum vertical velocity this component's entity can have during paragliding.
        public var maximumVerticalVelocity: CGFloat = 8.0 // m/s
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a paraglider component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = ParagliderComponent.sharedConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        performParaglidingIfNeeded()
    }
    
    // MARK: - Private
    
    private func performParaglidingIfNeeded() {
        guard
            let collider = entity?.component(ofType: ColliderComponent.self),
            let kinematicsBody = entity?.component(ofType: KinematicsBodyComponent.self)
            else {
                return
        }
        
        if collider.onGround == true {
            canParaglide = true
        }
        
        if isParagliding {
            if wasParagliding == false {
                if canMultiParaglide == false {
                    canParaglide = false
                }
                kinematicsBody.velocity.dy = 0
            }
            kinematicsBody.gravityInEffect = configuration.gravity
            kinematicsBody.currentMaximumVerticalVelocity = configuration.maximumVerticalVelocity
        }
    }
}

extension ParagliderComponent: StateResettingComponent {
    public func resetStates() {
        wasParagliding = isParagliding
        
        isParagliding = false
    }
}
