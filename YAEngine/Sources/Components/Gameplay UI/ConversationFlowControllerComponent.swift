//
//  ConversationFlowControllerComponent.swift
//  YAEngine
//

import GameplayKit

public extension Notification.Name {
    static let ConversationDidStart = Notification.Name("GlideSceneConversationDidStart")
    static let ConversationDidEnd = Notification.Name("GlideSceneConversationDidEnd")
}

/// Component that controls the flow of speech bubble entities for a given conversation
/// in its entity's scene.
final class ConversationFlowControllerComponent: GKComponent, GlideComponent {
    
    /// Conversation that this flow controller is currently managing.
    var conversation: Conversation? {
        didSet {
            if oldValue == nil && conversation != nil {
                NotificationCenter.default.post(name: .ConversationDidStart,
                                                object: self,
                                                userInfo: nil)
            } else if oldValue != nil && conversation == nil {
                NotificationCenter.default.post(name: .ConversationDidEnd,
                                                object: self,
                                                userInfo: nil)
            }
            
            oldValue?.speeches.forEach {
                $0.talker?.isInConversation = false
            }
            if let speechEntity = speechEntity {
                scene?.removeEntity(speechEntity)
                self.speechEntity = nil
            }
            conversation?.speeches.forEach {
                $0.talker?.isInConversation = true
            }
            currentSpeech = conversation?.speeches[0]
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard conversation != nil else {
            return
        }
        
        displaySpeechIfNeeded(deltaTime: seconds)
        proceedToNextSpeechIfNeeded()
    }
    
    // MARK: - Private
    
    /// Speech that's being currently displayed.
    private var currentSpeech: Speech?
    
    /// Entity for the speech that was being displayed in the last frame.
    private var speechEntity: GlideEntity?
    
    private func displaySpeechIfNeeded(deltaTime: TimeInterval) {
        guard let currentSpeech = currentSpeech else {
            return
        }
        if speechEntity == nil {
            let entity = speechEntity(currentSpeech, at: .zero)
            speechEntity = entity
            scene?.addEntity(entity)
        }
    }
    
    private func proceedToNextSpeechIfNeeded() {
        guard speechEntity?.component(ofType: SpeechFlowControllerComponent.self)?.isFinished == true else {
            return
        }
        guard let nextSpeech = speechEntity?.component(ofType: SpeechFlowControllerComponent.self)?.nextSpeech else {
            self.conversation = nil
            return
        }
        
        if let speechEntity = speechEntity {
            scene?.removeEntity(speechEntity)
            self.speechEntity = nil
        }
        currentSpeech = nextSpeech
    }
    
    private func speechEntity(_ speech: Speech, at position: CGPoint) -> GlideEntity {
        let entity = speech.speechBubbleTemplate.init(initialNodePosition: position, speech: speech)
        return entity
    }
}
