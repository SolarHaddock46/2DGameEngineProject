//
//  GlideSceneDelegate.swift
//  YAEngine
//

import Foundation

public protocol GlideSceneDelegate: AnyObject {
    
    /// Called when the paused states of the scene changes.
    func glideScene(_ scene: GlideScene, didChangePaused paused: Bool)
    
    /// Called when it is desired to end this scene with a predefined reason or with a custom context.
    func glideSceneDidEnd(_ scene: GlideScene, reason: GlideScene.EndReason?, context: [String: Any]?)
}
