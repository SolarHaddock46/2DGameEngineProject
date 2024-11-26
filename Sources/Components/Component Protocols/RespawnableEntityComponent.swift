//
//  RespawnableEntityComponent.swift
//  YAEngine
//

import Foundation

/// When adopted, a component can specify an offset value from its transform's
/// position when the camera of the scene is focused on that transform.
public protocol RespawnableEntityComponent {
    
    /// When provided, scene will call this closure to get an entity to be added
    /// when this entity is removed.
    var respawnedEntity: ((_ numberOfRespawnsLeft: Int) -> GlideEntity)? { get }
    
    /// Number of times that this component's entity can respawn.
    var numberOfRespawnsLeft: Int { get }
}
