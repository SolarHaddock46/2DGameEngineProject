//
//  BackgroundMusicComponent.swift
//  YAEngine
//
//  Created by Владимир Мацнев on 04.12.2024.
//


import GameplayKit
import SpriteKit

/// Component that is used to play background music (BGM) on the entity's scene.
/// Uses an `SKAudioNode` for playing the background music and provides methods
/// for controlling playback, such as play, pause, resume, and volume adjustment.
///
/// Required components: `SpriteNodeComponent`
public final class BackgroundMusicComponent: GKComponent, YAComponent {
    
    public static let componentPriority: Int = 950
    
    private var audioNode: SKAudioNode?
    
    /// Set the background music file to be played.
    ///
    /// - Parameters:
    ///     - fileName: Name of the background music file.
    ///     - fileExtension: File extension of the background music file.
    public func setBackgroundMusic(fileName: String, fileExtension: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            print("Background music file not found: $fileName).$fileExtension)")
            return
        }
        
        audioNode = SKAudioNode(url: url)
        audioNode?.autoplayLooped = true
    }
    
    /// Play the background music.
    public func playBackgroundMusic() {
        guard let audioNode = audioNode else {
            print("Background music not set.")
            return
        }
        
        let spriteNodeComponent = entity?.component(ofType: SpriteNodeComponent.self)
        let scene = spriteNodeComponent?.node.scene
        
        scene?.addChild(audioNode)
    }
    
    /// Pause the background music.
    public func pauseBackgroundMusic() {
        audioNode?.run(SKAction.pause())
    }
    
    /// Resume the background music.
    public func resumeBackgroundMusic() {
        audioNode?.run(SKAction.play())
    }
    
    /// Set the volume of the background music.
    ///
    /// - Parameters:
    ///     - volume: Volume level between 0.0 and 1.0.
    public func setBackgroundMusicVolume(_ volume: Float) {
        audioNode?.run(SKAction.changeVolume(to: volume, duration: 0))
    }
}
