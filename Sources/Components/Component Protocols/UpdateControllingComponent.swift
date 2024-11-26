//
//  UpdateControllingComponent.swift
//  YAEngine
//

import Foundation

/// When adopted, a component can decide if its entity should be updated
/// by the scene.
/// Entity's `didSkipUpdate()` will be called in the next frame if at least one of its
/// `UpdateControllingComponent`s return `false` for its `shouldEntityBeUpdated` value.
public protocol UpdateControllingComponent {
    
    /// `false` if the entity of this component should not be updated.
    var shouldEntityBeUpdated: Bool { get }
}
