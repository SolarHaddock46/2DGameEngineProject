//
//  TalkerComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that gives an entity the ability to keep a reference for being
/// in a conversation.
public class TalkerComponent: GKComponent, GlideComponent {
    
    /// `true` if the entity was in a conversation in the last frame.
    public private(set) var wasInConversation: Bool = false
    
    /// `true` if the entity is in a conversation in the current frame.
    /// This component blocks inputs for its entity while this value is `true`.
    public internal(set) var isInConversation: Bool = false
}

extension TalkerComponent: StateResettingComponent {
    public func resetStates() {
        wasInConversation = isInConversation
    }
}

extension TalkerComponent: InputControllingComponent {
    
    public static let componentPriority: Int = 610
    
    /// This entity will block inputs for its entity, if its scene's `activeConversation`
    /// contains this component in any of its speeches and this conversation's `blocksInputs`
    /// is `true`.
    public var shouldBlockInputs: Bool {
        if scene?.activeConversation?.containsTalker(self) == true {
            return scene?.activeConversation?.blocksInputs == true
        }
        return false
    }
}
