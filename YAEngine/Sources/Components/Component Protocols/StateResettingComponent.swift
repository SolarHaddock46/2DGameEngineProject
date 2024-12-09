//
//  StateResettingComponent.swift
//  YAEngine
//

import Foundation

/// Adopted by components to prepare their states for use in the rest of
/// their scene's update cycle. This preparation happens after the component's
/// update methods are called.
/// This is useful behavior for some components to interpret what has
/// changed since the update in the last frame to the current frame and prepare
/// this change information to be used by other elements of the scene in the
/// same frame.
/// `CollisionsController` of scene is an example element which gets use of
/// such information from `ColliderComponent`s.
public protocol StateResettingComponent {
    
    /// Called after `didUpdate(deltaTime:)` of `GlideComponent`.
    /// Don't call this method directly.
    func resetStates()
}
