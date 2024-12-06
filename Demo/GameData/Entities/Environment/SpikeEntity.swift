//
//  SpikeEntity.swift
//  glide Demo
//


import YAEngine
import SpriteKit

class SpikeEntity: YAEntity {
    
    override func setup() {
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 32, height: 32))
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.environment
        addComponent(spriteNodeComponent)
        
        let hazardComponent = HazardComponent()
        addComponent(hazardComponent)
        
        let colliderComponent = ColliderComponent(categoryMask: DemoCategoryMask.hazard,
                                                  size: CGSize(width: 20, height: 32),
                                                  offset: CGPoint(x: 0, y: -32),
                                                  leftHitPointsOffsets: (0, 0),
                                                  rightHitPointsOffsets: (0, 0),
                                                  topHitPointsOffsets: (0, 0),
                                                  bottomHitPointsOffsets: (0, 0))
        addComponent(colliderComponent)
        
        let animationSize = CGSize(width: 32, height: 32)
        let animationAction = TextureAnimation.Action(textureFormat: "spike_%d", numberOfFrames: 20, timePerFrame: 0.1)
        let openAndCloseAnimation = TextureAnimation(triggerName: "openAndClose",
                                                     offset: .zero,
                                                     size: animationSize,
                                                     action: animationAction,
                                                     loops: true)
        let textureAnimatorComponent = TextureAnimatorComponent(entryAnimation: openAndCloseAnimation)
        
        addComponent(textureAnimatorComponent)
        
        textureAnimatorComponent.enableAnimation(with: "openAndClose")
        
        let moveColliderDelay = SKAction.wait(forDuration: 1.0)
        let moveColliderUp = SKAction.customAction(withDuration: 0.5) { (_, secondsPassed) in
            colliderComponent.offset = CGPoint(x: 0, y: -32 + (secondsPassed / 0.5) * 32)
        }
        let moveColliderDown = SKAction.customAction(withDuration: 0.5) { (_, secondsPassed) in
            colliderComponent.offset = CGPoint(x: 0, y: (secondsPassed / 0.5) * -32)
        }
        let moveColliderUpAndDown = SKAction.repeatForever(SKAction.sequence([moveColliderDelay, moveColliderUp, moveColliderDown]))

        transform.node.run(moveColliderUpAndDown)
    }
    
}
