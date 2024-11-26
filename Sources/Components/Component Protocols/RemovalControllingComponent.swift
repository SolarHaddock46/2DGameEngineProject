//
//  RemovalControllingComponent.swift
//  YAEngine
//

import Foundation

/// When adopted, a component can decide if its entity can be removed
/// by the scene as a result of a removal event.
/// Entity will be removed if at least one of its `RemovalControllingComponent`s
/// return `true` for its `canEntityBeRemoved` value.
/// An example scenario where this might be useful is, an entity needs
/// to be removed but there needs to be an explosion animation played.
/// Adoption of this protocol by the component which will play this
/// animation ensures that the entity will not be removed until the
/// animation is done playing.
public protocol RemovalControllingComponent {
    
    /// `true` if the component is ready for removal of its entity.
    var canEntityBeRemoved: Bool { get }
}
