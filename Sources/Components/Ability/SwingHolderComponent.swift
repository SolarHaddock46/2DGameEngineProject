//
//  SwingHolderComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that gives an entity the ability to interact with swings.
public final class SwingHolderComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 690
    
    /// `true` if the entity was holding a swing in the last frame.
    public private(set) var wasHolding: Bool = false
    
    /// `true` if the entity is holding a swing in the current frame.
    public internal(set) var isHolding: Bool = false
    
    /// `true` if the entity can currently hold on to swing components.
    /// Purpose of this property is to let the entity jump off and get rid of
    /// contact with the entity of the related `SwingComponent`.
    /// Thus, value of this property gets to `false` between start of jumping
    /// and clearing contact with the swing.
    public internal(set) var canHold: Bool = true
    
    /// Direction of pushing the swing in the last frame.
    public private(set) var previousPushDirection: CircularDirection = .stationary
    
    /// Direction of pushing the swing in the current frame.
    public var pushDirection: CircularDirection = .stationary
    
    // MARK: - Configuration
    
    public struct Configuration {
        public var swingPushFactor: CGFloat = 25.0 // Degrees
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a swing holder component.
    ///
    /// - Parameters:
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(configuration: Configuration = SwingHolderComponent.sharedConfiguration) {
        self.configuration = configuration
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        adjustAngleOfSwingIfNeeded()
    }
    
    public func didUpdate(deltaTime seconds: TimeInterval) {
        updateCanHoldIfNeeded()
    }
    
    // MARK: - Private
    
    /// Transform of the swing that the entity is holding on to.
    var swingTransform: TransformNodeComponent?
    
    private func adjustAngleOfSwingIfNeeded() {
        guard isHolding else {
            return
        }
        
        guard let swingComponent = swingTransform?.entity?.component(ofType: SwingComponent.self) else {
            return
        }
        
        switch pushDirection {
        case .clockwise:
            swingComponent.applyPush(.clockwise(configuration.swingPushFactor))
        case .counterClockwise:
            swingComponent.applyPush(.counterClockwise(configuration.swingPushFactor))
        default:
            break
        }
    }
    
    private func updateCanHoldIfNeeded() {
        guard isHolding && canHold else {
            return
        }
        
        let jumpComponent = entity?.component(ofType: JumpComponent.self)
        
        if jumpComponent?.jumped == false && jumpComponent?.jumps == true {
            canHold = false
        }
    }
}

extension SwingHolderComponent: StateResettingComponent {
    public func resetStates() {
        wasHolding = isHolding
        previousPushDirection = pushDirection
        isHolding = false
        swingTransform = nil
        pushDirection = .stationary
    }
}
