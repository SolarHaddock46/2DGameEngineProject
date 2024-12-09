//
//  GemCounterEntity.swift
//  YAEngine Demo
//


import YAEngine
import SpriteKit
import GameplayKit

class GemCounterEntity: YAEntity {
    
    var numberOfGems: Int = 0 {
        didSet {
            updateNumberOfGems(to: numberOfGems)
        }
    }
    
    override func setup() {
        transform.usesProposedPosition = false
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 42, height: 42))
        spriteNodeComponent.zPositionContainer = YAZPositionContainer.camera
        spriteNodeComponent.offset = CGPoint(x: 31, y: -31)
        spriteNodeComponent.spriteNode.texture = SKTexture(nearestFilteredImageName: "gem_counter_icon")
        addComponent(spriteNodeComponent)
        
        let labelNodeComponent = LabelNodeComponent()
        labelNodeComponent.labelNode.zPosition = 2
        labelNodeComponent.labelNode.fontName = Font.gemCountTextFont(ofSize: gameplayTipTextFontSize).familyName
        labelNodeComponent.labelNode.fontSize = gemCountTextFontSize
        labelNodeComponent.labelNode.numberOfLines = 0
        labelNodeComponent.labelNode.horizontalAlignmentMode = .left
        labelNodeComponent.labelNode.verticalAlignmentMode = .center
        labelNodeComponent.offset = CGPoint(x: 65, y: -31)
        addComponent(labelNodeComponent)
        
        let gemCounterComponent = GemCounterComponent()
        addComponent(gemCounterComponent)
        
        updateNumberOfGems(to: 0)
    }
    
    func updateNumberOfGems(to gemCount: Int) {
        let labelNode = component(ofType: LabelNodeComponent.self)?.labelNode
        labelNode?.text = "\(gemCount)"
    }
}

class GemCounterComponent: GKComponent, YAComponent, NodeLayoutableComponent {
    
    func layout(scene: YAScene, previousSceneSize: CGSize) {
        transform?.currentPosition = CGPoint(x: -scene.size.width / 2, y: scene.size.height / 2)
    }
}
