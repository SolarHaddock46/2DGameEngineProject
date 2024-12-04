//
//  DemoEntityFactory.swift
//  glide Demo
//
//  Copyright (c) 2019 cocoatoucher user on github.com (https://github.com/cocoatoucher/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import YAEngine
import SpriteKit

/// This is an alternative approach to implementing separate `YAEntity` subclasses
/// for different entities.
class AnimationEntityFactory {
    
    static func explosionAnimationEntity(at position: CGPoint) -> YAEntity {
        let entity = AnimationEntityFactory.animationEntity(position: position, textureFormat: "explosion_%d", numberOfFrame: 59, offset: CGPoint(x: 0, y: 10))
        
        let audioPlayerComponent = AudioPlayerComponent()
        entity.addComponent(audioPlayerComponent)
        
        let explodeClip = AudioClip(triggerName: "Explode",
                                    fileName: "explosion",
                                    fileExtension: "wav",
                                    loops: false,
                                    isPositional: true)
        audioPlayerComponent.addClip(explodeClip)
        audioPlayerComponent.enableClip(with: "Explode")
        
        return entity
    }
    
    static func magicAnimationEntity(at position: CGPoint) -> YAEntity {
        return AnimationEntityFactory.animationEntity(position: position, textureFormat: "burst_effect_%d", numberOfFrame: 49, offset: CGPoint(x: 0, y: 0))
    }
    
    private static func animationEntity(position: CGPoint, textureFormat: String, numberOfFrame: Int, offset: CGPoint) -> YAEntity {
        let entity = YAEntity(initialNodePosition: position)
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: .zero)
        spriteNodeComponent.offset = CGPoint(x: 0, y: 3)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.explosions
        entity.addComponent(spriteNodeComponent)
        
        let timePerFrame: TimeInterval = 0.03
        let animationSize = CGSize(width: 50, height: 50)
        let explodeAction = TextureAnimation.Action(textureFormat: textureFormat,
                                                    numberOfFrames: numberOfFrame,
                                                    timePerFrame: timePerFrame)
        let idleAnimation = TextureAnimation(triggerName: "Idle",
                                             offset: offset,
                                             size: animationSize,
                                             action: explodeAction,
                                             loops: false)
        
        let animatorComponent = TextureAnimatorComponent(entryAnimation: idleAnimation)
        entity.addComponent(animatorComponent)
        
        let removeAfterTimeIntervalComponent = RemoveAfterTimeIntervalComponent(expireTime: 1.8)
        entity.addComponent(removeAfterTimeIntervalComponent)
        
        return entity
    }
}
