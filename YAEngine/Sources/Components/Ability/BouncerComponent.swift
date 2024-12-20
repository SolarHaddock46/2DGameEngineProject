//
//  BouncerComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that gives an entity the ability to gain speed in the given
/// directions so that it bounces. Useful for post enemy/hazard contacts.
///
/// Required components:
/// - `KinematicsBodyComponent`
public final class BouncerComponent: GKComponent, YAComponent {
    
    public static let componentPriority: Int = 660
    
    /// Bounce will automatically be triggered if entity's collider contacts a
    /// collider with this category mask.
    public let contactCategoryMasks: CategoryMask?
    
    /// `true` if the entity was bouncing in the last frame.
    public private(set) var didBounce: Bool = false
    
    /// `true` if there is a bouncing in the current frame.
    public private(set) var bounces: Bool = false
    
    /// Source sides for the bouncing. For example, if there is `bottom`
    /// in the impact sides, entity gains vertical velocity with a positive
    /// value towards upwards direction.
    public private(set) var impactSides: [ContactSide] = [.unspecified]
    
    public func bounce(withImpactSides impactSides: [ContactSide]) {
        self.bounces = true
        self.impactSides = impactSides
    }
    
    // MARK: - Configuration
    
    public struct Configuration {
        public var horizontalBouncingVelocity: CGFloat = 8.0 // m/s
        public var verticalBouncingVelocity: CGFloat = 8.0 // m/s
        public var restTimeBetweenBounces: TimeInterval = 0.8
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a bouncer component.
    ///
    /// - Parameters:
    ///     - contactCategoryMasks: Bounce will automatically be triggered if entity's
    /// collider contacts a collider with this category mask.
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(contactCategoryMasks: CategoryMask?,
                configuration: Configuration = BouncerComponent.sharedConfiguration) {
        self.contactCategoryMasks = contactCategoryMasks
        self.configuration = configuration
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        if bounceRestTimer > 0 {
            bounceRestTimer -= seconds
        }
        performBouncingIfNeeded()
    }
    
    // MARK: - Private
    
    private var bounceRestTimer: TimeInterval = 0.0
    
    private var directionsForImpactSides: CGPoint {
        var horizontalDirection: CGFloat = 1.0
        var verticalDirection: CGFloat = 1.0
        
        for side in impactSides {
            switch side {
            case .right:
                horizontalDirection = -1
            case .top:
                verticalDirection = -1
            default:
                break
            }
        }
        return CGPoint(x: horizontalDirection, y: verticalDirection)
    }
    
    private func performBouncingIfNeeded() {
        guard let kinematicsBody = entity?.component(ofType: KinematicsBodyComponent.self) else {
            return
        }
        
        if didBounce == false && bounces && bounceRestTimer <= 0 {
            bounceRestTimer = configuration.restTimeBetweenBounces
            let baseVelocity = CGVector(dx: abs(configuration.horizontalBouncingVelocity), dy: abs(configuration.verticalBouncingVelocity))
            kinematicsBody.velocity = CGVector(point: directionsForImpactSides * baseVelocity)
        }
    }
    
    public func handleNewContact(_ contact: Contact) {
        guard let contactCategoryMasks = contactCategoryMasks else {
            return
        }
        
        if let otherCategoryMask = contact.otherObject.colliderComponent?.categoryMask {
            if contactCategoryMasks.rawValue & otherCategoryMask.rawValue == otherCategoryMask.rawValue {
                bounce(withImpactSides: contact.contactSides)
            }
        }
    }
}

extension BouncerComponent: StateResettingComponent {
    public func resetStates() {
        didBounce = bounces
        
        bounces = false
        impactSides = [.unspecified]
    }
}
