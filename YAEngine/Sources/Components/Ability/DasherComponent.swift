//
//  DasherComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that makes an entity gain extra horizontal speed which will
/// last until taking a given distance.
public final class DasherComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 760
    
    /// Horizontal velocity to apply for dashing.
    public let velocity: CGFloat
    
    /// Target distance to take during dashing. After reaching this distance
    /// from start position, dashing stops.
    public let distance: CGFloat
    
    /// `true` if there was dashing in the last frame.
    public private(set) var didDash: Bool = false
    
    /// Set to `true` to perform a dash given that the other conditions are met.
    /// If an entity has `PlayableCharacterComponent`, this property
    /// is automatically set for this component where needed.
    public var dashes: Bool = false
    
    // MARK: - Initialize
    
    /// Create a dasher component.
    ///
    /// - Parameters:
    ///     - velocity: Horizontal velocity to apply for dashing.
    ///     - distance: Target distance to take during dashing.
    public init(velocity: CGFloat, distance: CGFloat) {
        self.velocity = velocity
        self.distance = distance
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        dashIfNeeded()
    }
    
    // MARK: - Private
    
    /// Position that the dashing has started from.
    private var startPosition: CGFloat = 0
    /// Diretion for the dashing that will stay fixed until dashing stops.
    private var direction: TransformNodeComponent.HeadingDirection = .right
    
    private func dashIfNeeded() {
        guard let transform = transform else {
            return
        }
        
        if didDash == false && dashes {
            startPosition = transform.node.position.x
            direction = transform.headingDirection
        }
        
        if dashes {
            let kinematicsBody = entity?.component(ofType: KinematicsBodyComponent.self)
            kinematicsBody?.velocity.dx = (direction == .left) ? -velocity : velocity
            
            if let collider = entity?.component(ofType: ColliderComponent.self) {
                if collider.pushesLeftWall || collider.pushesRightWall {
                    endDashing()
                }
            }
            
            switch direction {
            case .right:
                if transform.proposedPosition.x >= startPosition + distance {
                    endDashing()
                }
            case .left:
                if transform.proposedPosition.x <= startPosition - distance {
                    endDashing()
                }
            }
        }
    }
    
    private func endDashing() {
        dashes = false
        startPosition = 0
        entity?.component(ofType: KinematicsBodyComponent.self)?.velocity.dx = 0
    }
}

extension DasherComponent: StateResettingComponent {
    public func resetStates() {
        didDash = dashes
    }
}
