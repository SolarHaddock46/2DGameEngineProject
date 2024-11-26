//
//  GlideScene+SpeechBubbles.swift
//  YAEngine
//

import SpriteKit

extension GlideScene {
    
    /// Call this function to start the flow of the speeches of a conversation.
    /// After calling this function provided template entities in the `Speech` objects will be
    /// initialized and added to the scene in accordance with the flow.
    ///
    /// - Parameters:
    ///     - conversation: Conversation to start the flow for.
    public func startFlowForConversation(_ conversation: Conversation) {
        conversationFlowControllerEntity.component(ofType: ConversationFlowControllerComponent.self)?.conversation = conversation
    }
    
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
