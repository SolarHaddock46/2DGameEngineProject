//
//  SpeechFlowControllerComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that controls the flow of text blocks and options in a single speech.
public final class SpeechFlowControllerComponent: GKComponent, GlideComponent {
    
    /// Speech value that shoud be controlled by this component.
    public let speech: Speech
    
    /// Reference to the speech that will come after the speech of the component
    /// within a conversation.
    public private(set) var nextSpeech: Speech?
    
    /// `true` if the current text part of this controller component is the last
    /// text part of the speech. Option values of the speech should only be displayed
    /// only for the last text part.
    public var shouldDisplayOptions: Bool {
        return currentTextBlockIndex == speech.textBlocks.count - 1
    }
    
    // MARK: - Configuration
    
    public struct Configuration {
        /// Will ignore user inputs during that time after a new text part is selected.
        public var minumumDisplayTimeForTextBlock: TimeInterval = 0.3 // seconds
    }
    /// Configuration shared by all components of this class.
    public static var sharedConfiguration = Configuration()
    /// Configuration that is used by only this instance of the component.
    /// Default value is `sharedConfiguration`.
    public let configuration: Configuration
    
    // MARK: - Initialize
    
    /// Create a speech flow controller component.
    ///
    /// - Parameters:
    ///     - speech: Speech value that shoud be controlled by this component.
    public init(speech: Speech, configuration: Configuration = SpeechFlowControllerComponent.sharedConfiguration) {
        self.speech = speech
        self.configuration = configuration
        super.init()
        if speech.textBlocks.isEmpty {
            isFinished = true
        }
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Call this function when the conversation is ready to proceed with the
    /// next speech.
    ///
    /// - Parameters:
    ///     - nextSpeech: Speech to proceed with. `nil` if the conversation has finished.
    public func proceed(to nextSpeech: Speech?) {
        self.nextSpeech = nextSpeech
        self.submits = true
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        guard isFinished == false else {
            return
        }
        
        updateLabel(textBlockIndex: currentTextBlockIndex)
        
        textBlockDisplayTimer += seconds
        
        proceedToNextTextBlockIfNeeded()
    }
    
    // MARK: - Private
    
    private var submits: Bool = false
    private(set) var isFinished: Bool = false
    private var currentTextBlockIndex: Int = 0
    private var textBlockDisplayTimer: TimeInterval = 0
    
    private func updateLabel(textBlockIndex: Int) {
        let speechBubbleEntity = entity as? SpeechBubbleTemplateEntity
        speechBubbleEntity?.updateText(to: currentTextBlockIndex)
    }
    
    private func proceedToNextTextBlockIfNeeded() {
        guard submits else {
            return
        }
        
        guard textBlockDisplayTimer >= configuration.minumumDisplayTimeForTextBlock else {
            return
        }
        currentTextBlockIndex += 1
        textBlockDisplayTimer = 0
        
        if currentTextBlockIndex == speech.textBlocks.count {
            isFinished = true
        }
    }
}

extension SpeechFlowControllerComponent: StateResettingComponent {
    public func resetStates() {
        submits = false
    }
}
