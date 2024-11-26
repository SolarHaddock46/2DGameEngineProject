//
//  Conversation.swift
//  YAEngine
//

import Foundation

/// Represents list of speeches.
public class Conversation {
    
    /// Speeches that are part of this conversation.
    public let speeches: [Speech]
    /// `true` if the inputs should be blocked if this conversation is active in the scene.
    public let blocksInputs: Bool
    
    // MARK: - Initialize
    
    /// Create a speech.
    ///
    /// - Parameters:
    ///     - speeches: Speeches that are part of this conversation.
    ///     - blocksInputs: `true` if the inputs should be blocked if this conversation is
    /// active in the scene.
    public init(speeches: [Speech],
                blocksInputs: Bool) {
        self.speeches = speeches
        self.blocksInputs = blocksInputs
    }
    
    public func containsTalker(_ talkerComponent: TalkerComponent) -> Bool {
        return speeches.filter { $0.talker == talkerComponent }.isEmpty == false
    }
}
