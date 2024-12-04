//
//  GlideSceneDelegate.swift
//  YAEngine
//

import Foundation

public protocol YASceneDelegate: AnyObject {
    
    /// Called when the paused states of the scene changes.
    func yaScene(_ scene: YAScene, didChangePaused paused: Bool)
    
    /// Called when it is desired to end this scene with a predefined reason or with a custom context.
    func yaSceneDidEnd(_ scene: YAScene, reason: YAScene.EndReason?, context: [String: Any]?)
}
