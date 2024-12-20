//
//  YAComponent.swift
//  YAEngine
//

import GameplayKit

/// Basic component protocol that should be adopted by all components
/// for full compatibility of features.
public protocol YAComponent {
    
    /// Priority of the component within other components of its entity.
    /// Components with priority of lower values will be updated before
    /// components with priority of higher values.
    /// Default value is `0`.
    static var componentPriority: Int { get }
    
    /// Convenience reference to `TransformNodeComponent` of this component's
    /// entity.
    var transform: TransformNodeComponent? { get }
    
    /// Convenience reference to the scene of this component's entity.
    var scene: YAScene? { get }
    
    /// Convenience reference to the current time of the scene of this
    /// component's entity.
    var currentTime: TimeInterval? { get }
    
    /// Called in either of those two situations:
    /// - Component is just added to an entity with a non empty scene.
    /// - Component is already a member of an entity's component and that
    /// entity's transform is just added to a scene.
    /// Don't call this method directly.
    func start()
    
    /// Called prior to calling `update(deltaTime:)` of `GKComponent`.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - seconds: Seconds passed since the last frame.
    func willUpdate(deltaTime seconds: TimeInterval)
    
    /// Called after calling `update(deltaTime:)` of `GKComponent`.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - seconds: Seconds passed since the last frame.
    func didUpdate(deltaTime seconds: TimeInterval)
    
    /// Called after the camera entity of the entity's scene is updated.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - seconds: Seconds passed since the last frame.
    ///     - cameraComponent: Camera component of the scene's camera entity.
    func updateAfterCameraUpdate(deltaTime seconds: TimeInterval, cameraComponent: CameraComponent)
    
    /// Called if the entity has just encountered a contact with another
    /// element(such as collider tiles) or entity in the scene.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - contact: Values on the contact and contacting objects.
    func handleNewContact(_ contact: Contact)
    
    /// Called if the entity has stayed in contact since previous frames
    /// with another element(such as collider tiles) or entity in the scene.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - contact: Values on the contact and contacting objects.
    func handleExistingContact(_ contact: Contact)
    
    /// Called if the entity has finished a contact with another element
    /// (such as collider tiles) or entity in the scene.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - contact: Values on the contact and contacting objects.
    func handleFinishedContact(_ contact: Contact)
    
    /// Called if the entity has just encountered a collision with another
    /// element(such as collider tiles) or entity in the scene.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - contact: Values on the contact and contacting objects.
    func handleNewCollision(_ collision: Contact)
    
    /// Called if the entity has stayed in collision since previous frames
    /// with another element(such as collider tiles) or entity in the scene.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - contact: Values on the contact and contacting objects.
    func handleExistingCollision(_ collision: Contact)
    
    /// Called if the entity has finished a collision with another element
    /// (such as collider tiles) or entity in the scene.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - contact: Values on the contact and contacting objects.
    func handleFinishedCollision(_ collision: Contact)
    
    /// Called at the end of each frame.
    /// Don't call this method directly
    func didFinishUpdate()
    
    /// Called if the component's entity chose to skip updates.
    /// Don't call this method directly.
    func didSkipUpdate()
    
    /// Called if the entity of the component will be removed from scene.
    /// Don't call this method directly.
    func entityWillBeRemovedFromScene()
    
    /// Called before entity will be removed from the scene.
    /// Don't call this method directly.
    func willBeRemovedFromEntity()
}

public extension YAComponent where Self: GKComponent {
    
    static var componentPriority: Int { return 0 }
    
    var transform: TransformNodeComponent? {
        return (entity as? YAEntity)?.transform
    }
    
    var scene: YAScene? {
        return transform?.node.scene as? YAScene
    }
    
    var currentTime: TimeInterval? {
        return (entity as? YAEntity)?.currentTime
    }
    
    func start() {}
    
    func willUpdate(deltaTime seconds: TimeInterval) {}
    func didUpdate(deltaTime seconds: TimeInterval) {}
    func updateAfterCameraUpdate(deltaTime seconds: TimeInterval, cameraComponent: CameraComponent) {}
    
    func handleNewContact(_ contact: Contact) {}
    func handleExistingContact(_ contact: Contact) {}
    func handleFinishedContact(_ contact: Contact) {}
    
    func handleNewCollision(_ collision: Contact) {}
    func handleExistingCollision(_ collision: Contact) {}
    func handleFinishedCollision(_ collision: Contact) {}
    
    func didFinishUpdate() {}
    
    func didSkipUpdate() {}
    func entityWillBeRemovedFromScene() {}
    func willBeRemovedFromEntity() {}
}
