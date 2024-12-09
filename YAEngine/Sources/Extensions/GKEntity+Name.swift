//
//  GKEntity+Name.swift
//  YAEngine
//

import GameplayKit

public extension GKEntity {
    
    /// Returns name of the transform component's node if this entity
    /// is a `GlideEntity`.
    /// Returns `nil` otherwise.
    @objc var name: String? {
        if let yaEntity = self as? YAEntity {
            return yaEntity.transform.node.name
        }
        return nil
    }
}
