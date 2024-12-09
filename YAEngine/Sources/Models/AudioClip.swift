//
//  AudioClip.swift
//  YAEngine
//

import CoreGraphics
import SpriteKit
import AVFoundation

/// Wraps an audio node and its properties.
public class AudioClip {
    
    /// Id that will be used to trigger playing this animation.
    public let triggerName: String
    
    /// `true` if the audio clip is looped.
    public let loops: Bool
    
    /// `true` if the clip plays positional audio.
    public let isPositional: Bool
    
    /// Duration of the animation calculated from the given
    /// audio clip file name.
    public let duration: TimeInterval?
    
    /// Create an audio clip.
    ///
    /// - Parameters:
    ///     - triggerName: Id that will be used to trigger playing this audio clip.
    ///     - fileName: Name of the audio file.
    ///     - fileExtension: Extension of the audio file.
    ///     - loops: `true` if the audio clip is looped.
    ///     - isPositional: `true` if the clip plays positional audio. Default value is `false`.
    public init(triggerName: String,
                fileName: String,
                fileExtension: String,
                loops: Bool,
                isPositional: Bool = false) {
        self.id = "\(mach_absolute_time())"
        self.triggerName = triggerName
        self.loops = loops
        self.isPositional = isPositional
        
        self.audioNode = SKAudioNode(fileNamed: fileName + "." + fileExtension)
        audioNode.isPositional = isPositional
        audioNode.autoplayLooped = loops
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            let player = try? AVAudioPlayer(contentsOf: url)
            self.duration = player?.duration
        } else {
            self.duration = nil
        }
    }
    
    // MARK: - Private
    
    let id: String
    
    /// Whether that audio clip is currently triggered.
    /// Will be reset to `false` in next update cycle.
    var isTriggerEnabled: Bool = false
    
    let audioNode: SKAudioNode
    
    func play() {
        guard audioNode.autoplayLooped == false else {
            return
        }
        
        audioNode.removeAllActions()
        
        let waitUntilFinish = SKAction.wait(forDuration: duration ?? 0)
        let group = SKAction.group([SKAction.play(), waitUntilFinish])
        audioNode.run(group) { [weak audioNode] in
            audioNode?.removeFromParent()
        }
    }
    
}
