//
//  SpeechOption.swift
//  YAEngine
//

import Foundation

/// Represents options to choose from at the end of a speech.
public struct SpeechOption {
    public let text: String
    public let targetSpeech: Speech
    
    public init(text: String, targetSpeech: Speech) {
        self.text = text
        self.targetSpeech = targetSpeech
    }
}
