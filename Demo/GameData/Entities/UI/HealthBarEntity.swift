//
//  HealthBarEntity.swift
//  glide Demo
//


import YAEngine
import SpriteKit
import GameplayKit

class HealthBarEntity: YAEntity {
    
    let numberOfHearts: Int
    
    init(numberOfHearts: Int) {
        self.numberOfHearts = numberOfHearts
        super.init(initialNodePosition: .zero, positionOffset: .zero)
    }
    
    override func setup() {
        transform.usesProposedPosition = false
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 120, height: 32))
        spriteNodeComponent.zPositionContainer = YAZPositionContainer.camera
        spriteNodeComponent.offset = CGPoint(x: 80, y: -36)
        addComponent(spriteNodeComponent)
        
        let healthBarComponent = HealthBarComponent()
        addComponent(healthBarComponent)
        
        let updatableHealthBarComponent = UpdatableHealthBarComponent(numberOfHearts: numberOfHearts) { [weak self] remainingHearts in
            guard let self = self else { return }
            let texture = SKTexture(nearestFilteredImageName: String(format: "hearts_%d", remainingHearts))
            self.component(ofType: SpriteNodeComponent.self)?.spriteNode.texture = texture
        }
        addComponent(updatableHealthBarComponent)
    }
}

class HealthBarComponent: GKComponent, YAComponent, NodeLayoutableComponent {
    
    func layout(scene: YAScene, previousSceneSize: CGSize) {
        let offset: CGFloat = 50
        transform?.currentPosition = CGPoint(x: -scene.size.width / 2, y: scene.size.height / 2 - offset)
    }
}
