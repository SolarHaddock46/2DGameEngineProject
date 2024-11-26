//
//  RemoveAfterTimeIntervalComponent.swift
//  YAEngine
//

import GameplayKit

/// This component sets its entity's `canBeRemoved` to 'true' after a given period of time
/// starting with the first time this entity.
public class RemoveAfterTimeIntervalComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 500
    
    /// Total amount of time that the entity will be removed from its scene
    /// in seconds.
    public let expireTime: TimeInterval
    
    /// Callback that returns an animation entity to be added to scene right before
    /// removing this entity.
    public let removalAnimationEntity: (() -> GlideEntity?)?
    
    // MARK: - Initialize
    
    /// Create a remove after time interval component.
    ///
    /// - Parameters:
    ///     - expireTime: Total amount of time that the entity will be removed from
    /// its scene in seconds.
    ///     - removalAnimationEntity: Callback that returns an animation entity to be added to
    /// scene right before removing this entity.
    public init(expireTime: TimeInterval, removalAnimationEntity: (() -> GlideEntity?)? = nil) {
        self.expireTime = expireTime
        self.removalAnimationEntity = removalAnimationEntity
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func update(deltaTime seconds: TimeInterval) {
        timePassed += seconds
        if timePassed >= expireTime {
            isExpired = true
            if let removalAnimationEntity = removalAnimationEntity?() {
                scene?.addEntity(removalAnimationEntity)
            }
        }
    }
    
    public func willBeRemovedFromEntity() {
        prepareForReuse()
    }
    
    public func entityWillBeRemovedFromScene() {
        prepareForReuse()
    }
    
    // MARK: - Private
    
    private var timePassed: TimeInterval = 0
    private var isExpired: Bool = false
    
    private func prepareForReuse() {
        timePassed = 0
        isExpired = false
    }
}

extension RemoveAfterTimeIntervalComponent: RemovalControllingComponent {
    public var canEntityBeRemoved: Bool {
        return isExpired
    }
}
