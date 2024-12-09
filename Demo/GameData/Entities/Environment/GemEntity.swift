//
//  GemEntity.swift
//  YAEngine Demo
//


import YAEngine
import SpriteKit

class GemEntity: YAEntity {
    
    let colliderSize = CGSize(width: 14, height: 14)
    
    init(bottomLeftPosition: CGPoint) {
        super.init(initialNodePosition: bottomLeftPosition, positionOffset: CGPoint(size: colliderSize / 2))
    }
    
    override func setup() {
        let collider = ColliderComponent(categoryMask: DemoCategoryMask.collectible,
                                         size: colliderSize,
                                         offset: .zero,
                                         leftHitPointsOffsets: (0, 0),
                                         rightHitPointsOffsets: (0, 0),
                                         topHitPointsOffsets: (0, 0),
                                         bottomHitPointsOffsets: (0, 0))
        addComponent(collider)
        
        let spriteNode = SpriteNodeComponent(nodeSize: colliderSize)
        spriteNode.zPositionContainer = DemoZPositionContainer.environment
        addComponent(spriteNode)
        
        let textureAction = TextureAnimation.Action(textureFormat: "gem_red_%d",
                                                    numberOfFrames: 2,
                                                    timePerFrame: 0.1)
        let textureAnimation = TextureAnimation(triggerName: "idle",
                                                offset: .zero,
                                                size: colliderSize,
                                                action: textureAction,
                                                loops: true)
        let textureAnimator = TextureAnimatorComponent(entryAnimation: textureAnimation)
        addComponent(textureAnimator)
        
        let collectibleComponent = CollectibleComponent()
        addComponent(collectibleComponent)
    }
    
}
