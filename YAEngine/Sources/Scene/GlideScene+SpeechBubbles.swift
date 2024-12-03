//
//  GlideScene+SpeechBubbles.swift
//  YAEngine
//

import SpriteKit

extension GlideScene {
    
    // MARK: - End scene
    
    /// Informs `glideSceneDelegate` of this scene to end the scene.
    ///
    /// - Parameters:
    ///     - reason: A predefined reason for ending the scene if any.
    ///     - context: Additional information to be used in context of ending the scene.
    public func endScene(reason: GlideScene.EndReason?, context: [String: Any]? = nil) {
        glideSceneDelegate?.glideSceneDidEnd(self, reason: reason, context: context)
    }
}
