//
//  SpeechBubbleTemplateEntity.swift
//  YAEngine
//

import Foundation
import CoreGraphics

/// Template entity to be used a base class for speech bubbles that
/// visually represent individual text parts of speeches in a conversation.
/// Provided templates are initialized and added to scene by the entity
/// with`ConversationFlowControllerComponent` of the scene.
open class SpeechBubbleTemplateEntity: GlideEntity {
    
    /// Speech that is displayed by this entity.
    public let speech: Speech
    
    // MARK: - Initialize
    
    /// Create a speech bubble template entity.
    ///
    ///
    /// - Parameters:
    ///     - initialNodePosition: Initial position for the transform of the entity.
    ///     - speech: Speech that is displayed by this entity.
    public required init(initialNodePosition: CGPoint,
                         speech: Speech) {
        self.speech = speech
        super.init(initialNodePosition: initialNodePosition, positionOffset: .zero)
    }
    
    /// This function is called when the `SpeechFlowControllerComponent`
    /// controlling the `Speech` of this component proceeds from one text part
    /// of the speech to the next.
    ///
    /// - Parameters:
    ///     - textBlockIndex: Index of the text part of `Speech` to be displayed.
    open func updateText(to textBlockIndex: Int) {}
}
