//
//  NodeLayoutableComponent.swift
//  YAEngine
//

import CoreGraphics

/// When adopted, layout method in this protocol is called for the component
/// to layout its rendered nodes in respect to scene size.
public protocol NodeLayoutableComponent {
    
    /// Apply layout for the nodes of the component which should be sized
    /// in respect to current scene size.
    /// Don't call this method directly.
    ///
    /// - Parameters:
    ///     - scene: Scene of the component's entity.
    ///     - previousSceneSize: Size of the scene before in the last frame.
    func layout(scene: GlideScene, previousSceneSize: CGSize)
}
