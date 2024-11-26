//
//  LadderClimberComponent.swift
//  YAEngine
//

import GameplayKit

extension LadderClimberComponent {
    public enum MovingDirection {
        case none
        case upwards
        case downwards
    }
}

/// Component that gives an entity the ability to interact with ladders.
///
/// Required components:
/// - `KinematicsBodyComponent`
public final class LadderClimberComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 700
    
    /// `true` if the entity was contacting a ladder in the last frame.
    public private(set) var wasContactingLadder: Bool = false
    
    /// `true` if the entity is contacting a ladder in the current frame.
    public internal(set) var isContactingLadder: Bool = false
    
    /// `true` if the entity was climbing up or down a ladder in the last frame.
    public private(set) var wasHolding: Bool = false
    
    /// `true` if the entity is climbing up or down a ladder in the current frame.
    public internal(set) var isHolding: Bool = false
    
    /// Direction of moving on the ladder, climbing or descending.
    /// If an entity has `PlayableCharacterComponent`, this property
    /// is automatically set for this component where needed.
    public var movingDirection: MovingDirection = .none
    
    // MARK: - Configuration
    
    public struct Configuration {
        public var velocityOnLadder: CGFloat = 5.0 // m/s
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a ladder climber component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = LadderClimberComponent.sharedConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        handleHoldingLadder()
    }
    
    public func didUpdate(deltaTime seconds: TimeInterval) {
        handleJumpFromLadderIfNeeded()
    }
    
    // MARK: - Private
    
    private func handleHoldingLadder() {
        guard
            let kinematicsBodyComponent = entity?.component(ofType: KinematicsBodyComponent.self),
            isHolding
            else {
                return
        }
        
        kinematicsBodyComponent.velocity.dx = 0
        kinematicsBodyComponent.gravityInEffect = 0
        
        switch movingDirection {
        case .upwards:
            kinematicsBodyComponent.velocity.dy = abs(configuration.velocityOnLadder)
        case .downwards:
            kinematicsBodyComponent.velocity.dy = -abs(configuration.velocityOnLadder)
        default:
            kinematicsBodyComponent.velocity.dy = 0
        }
    }
    
    private func handleJumpFromLadderIfNeeded() {
        guard isHolding else {
            return
        }
        
        let jumpComponent = entity?.component(ofType: JumpComponent.self)
        
        if jumpComponent?.jumped == false && jumpComponent?.jumps == true {
            isHolding = false
        }
    }
}

extension LadderClimberComponent: StateResettingComponent {
    public func resetStates() {
        wasHolding = isHolding
        wasContactingLadder = isContactingLadder
        isContactingLadder = false
    }
}
