//
//  GameplayTipEntity.swift
//  Glide
//


import YAEngine
import GameplayKit

class GameplayTipEntity: YAEntity {
    
    let text: String
    let frameWidth: CGFloat
    
    init(initialNodePosition: CGPoint, text: String, frameWidth: CGFloat) {
        self.text = text
        self.frameWidth = frameWidth + 20.0
        super.init(initialNodePosition: initialNodePosition, positionOffset: .zero)
    }
    
    override func setup() {
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: .zero)
        
        spriteNodeComponent.spriteNode.texture = SKTexture(nearestFilteredImageName: "gameplay_tip_frame")
        spriteNodeComponent.spriteNode.centerRect = CGRect(x: 8.0/18.0, y: 8.0/18.0, width: 2.0/18.0, height: 2.0/18.0)
        
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.environment
        addComponent(spriteNodeComponent)
        
        let labelNodeComponent = LabelNodeComponent()
        labelNodeComponent.labelNode.zPosition = 10
        labelNodeComponent.labelNode.fontName = Font.gameplayTipTextFont(ofSize: gameplayTipTextFontSize).familyName
        labelNodeComponent.labelNode.fontSize = gameplayTipTextFontSize
        labelNodeComponent.labelNode.text = text
        labelNodeComponent.labelNode.numberOfLines = 0
        labelNodeComponent.labelNode.preferredMaxLayoutWidth = frameWidth - 20
        labelNodeComponent.labelNode.horizontalAlignmentMode = .center
        labelNodeComponent.labelNode.verticalAlignmentMode = .center
        addComponent(labelNodeComponent)
        
        let layoutComponent = SceneAnchoredSpriteLayoutComponent()
        layoutComponent.widthConstraint = NodeLayoutConstraint.constant(frameWidth)
        layoutComponent.heightConstraint = NodeLayoutConstraint.constant(labelNodeComponent.labelNode.frame.height + 20.0)
        addComponent(layoutComponent)
    }
    
}
