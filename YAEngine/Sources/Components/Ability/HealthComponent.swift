//
//  HealthComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that gives an entity health and life properties, e.g. number of lives.
/// This also gives ability to get damaged and die.
public final class HealthComponent: GKComponent, YAComponent {
    
    public static let componentPriority: Int = 720
    
    /// Value for maximum amount of lives this component's entity has.
    public let maximumHealth: CGFloat
    
    /// Value for remaining amount of lives this component's entity has.
    public private(set) var remainingHealth: CGFloat = 0
    
    /// `true` if the entity was dead in the last frame.
    public private(set) var wasDead: Bool = false
    
    /// `true` if the entity is dead.
    /// Call `kill()` on this component to make an entity dead.
    public private(set) var isDead: Bool = false
    
    /// `true` if entity is protected from decreasing its number of lives.
    public var isInvincible: Bool = false {
        didSet {
            timePassedWithInvincibility = 0
        }
    }
    
    // MARK: - Configuration
    
    public struct Configuration {
        /// Duration of invincibility in seconds.
        public var invincibleDuration: TimeInterval = 1 // s
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a health component.
    ///
    /// - Parameters:
    ///     - maximumHealth: Value for maximum amount of lives this component's
    /// entity has.
    ///     - configuration: Configuration used by this component.
    /// Default value is `sharedConfiguration`.
    public init(maximumHealth: CGFloat, configuration: Configuration = HealthComponent.sharedConfiguration) {
        self.maximumHealth = maximumHealth
        self.configuration = configuration
        super.init()
        remainingHealth = maximumHealth
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func didUpdate(deltaTime seconds: TimeInterval) {
        handleInvincibility(deltaTime: seconds)
    }
    
    /// Attempt to decrease the number of lives by 1 or kill the entity if there
    /// are no more lives left.
    /// If entity's `canTakeDamage` returns `false` via its components, this method
    /// will have no effect.
    @discardableResult
    public func applyDamage(_ damageAmount: CGFloat) -> Bool {
        guard (entity as? YAEntity)?.canTakeDamage == true else {
            return false
        }
        
        remainingHealth = max(remainingHealth - damageAmount, 0)
        if remainingHealth > 0 {
            entity?.component(ofType: BlinkerComponent.self)?.blinks = true
        } else if remainingHealth == 0 {
            kill()
        }
        return true
    }
    
    /// Marks the component as dead which will make its entity stop receiving
    /// regular updates and start getting `didSkipUpdate()` calls.
    public func kill() {
        isDead = true
        entity?.component(ofType: ColliderComponent.self)?.isEnabled = false
    }
    
    // MARK: - Private
    
    /// Value of seconds passed since the beginning of invincibility.
    private var timePassedWithInvincibility: TimeInterval = 0.0
    
    /// Start or stop the invincibility of the component's entity.
    private func handleInvincibility(deltaTime seconds: TimeInterval) {
        guard isInvincible else {
            return
        }
        
        timePassedWithInvincibility += seconds
        if timePassedWithInvincibility >= configuration.invincibleDuration {
            isInvincible = false
        }
    }
}

extension HealthComponent: StateResettingComponent {
    public func resetStates() {
        wasDead = isDead
    }
}

extension HealthComponent: UpdateControllingComponent {
    public var shouldEntityBeUpdated: Bool {
        return isDead == false
    }
}

extension HealthComponent: DamageControllingComponent {
    var canEntityTakeDamage: Bool {
        return isInvincible == false
    }
}

extension HealthComponent: InputControllingComponent {
    /// This component blocks its entity from receiving inputs.
    /// Until invincibility is finished or its collider touches the ground
    /// if the entity has a collider.
    public var shouldBlockInputs: Bool {
        guard
            isInvincible,
            entity?.component(ofType: ColliderComponent.self) == nil ||
                entity?.component(ofType: ColliderComponent.self)?.onGround == false
            else {
                return false
        }
        return true
    }
}
