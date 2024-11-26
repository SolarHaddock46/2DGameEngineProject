//
//  GlideScene.EndReason.swift
//  YAEngine
//

import Foundation

public extension GlideScene {
    
    /// Represents predefined values on the reason for ending a scene.
    enum EndReason {
        /// There are no more entities with a `PlayableCharacterComponent` in the scene.
        case hasNoMorePlayableEntities
        /// A playable character has reached finish checkpoint.
        case playableCharacterReachedFinishCheckpoint
    }
}
