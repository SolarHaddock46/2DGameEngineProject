//
//  EagleEntity.swift
//  YAEngine Demo
//


import YAEngine
import GameplayKit

class EagleEntity: YAEntity {
    
    let colliderSize = CGSize(width: 41, height: 21)
    
    init(initialNodePosition: CGPoint) {
        super.init(initialNodePosition: initialNodePosition, positionOffset: CGPoint(size: colliderSize / 2))
    }
    
    override func setup() {
        name = "Eagle"
        
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: colliderSize)
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.npcs
        addComponent(spriteNodeComponent)
        
        let colliderComponent = ColliderComponent(categoryMask: DemoCategoryMask.npc,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (5, 5),
                                                  rightHitPointsOffsets: (5, 5),
                                                  topHitPointsOffsets: (10, 10),
                                                  bottomHitPointsOffsets: (10, 10))
        addComponent(colliderComponent)
        
        var kinematicsBodyConfiguration = KinematicsBodyComponent.sharedConfiguration
        kinematicsBodyConfiguration.maximumVerticalVelocity = 2.0
        let kinematicsBodyComponent = KinematicsBodyComponent(configuration: kinematicsBodyConfiguration)
        addComponent(kinematicsBodyComponent)
        
        var verticalMovementConfiguration = VerticalMovementComponent.sharedConfiguration
        verticalMovementConfiguration.acceleration = 80.0
        verticalMovementConfiguration.deceleration = 50.0
        let verticalMovementComponent = VerticalMovementComponent(movementStyle: .accelerated, configuration: verticalMovementConfiguration)
        addComponent(verticalMovementComponent)
        
        let moveComponent = SelfMoveComponent(movementAxes: .vertical)
        addComponent(moveComponent)
        
        let hazardComponent = HazardComponent()
        addComponent(hazardComponent)
        
        let eagleComponent = EagleComponent()
        addComponent(eagleComponent)
        
        setupTextureAnimations()
    }
    
    func setupTextureAnimations() {
        let timePerFrame: TimeInterval = 0.1
        
        let animationSize = colliderSize
        // Idle
        let idleAction = TextureAnimation.Action(textureFormat: "eagle_idle_%d",
                                                 numberOfFrames: 7,
                                                 timePerFrame: timePerFrame,
                                                 shouldGenerateNormalMaps: false)
        let idleAnimation = TextureAnimation(triggerName: "Idle",
                                             offset: .zero,
                                             size: animationSize,
                                             action: idleAction,
                                             loops: true)
        
        let animatorComponent = TextureAnimatorComponent(entryAnimation: idleAnimation)
        addComponent(animatorComponent)
        
        // Fall
        let fallAction = TextureAnimation.Action(textureFormat: "eagle_fall_%d",
                                                 numberOfFrames: 1,
                                                 timePerFrame: timePerFrame,
                                                 shouldGenerateNormalMaps: true)
        let fallAnimation = TextureAnimation(triggerName: "Fall",
                                             offset: .zero,
                                             size: animationSize,
                                             action: fallAction,
                                             loops: false)
        animatorComponent.addAnimation(fallAnimation)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let kinematicsBody = component(ofType: KinematicsBodyComponent.self) else {
            return
        }
        if kinematicsBody.velocity.dy < 0 {
            component(ofType: TextureAnimatorComponent.self)?.enableAnimation(with: "Fall")
        } else {
            component(ofType: TextureAnimatorComponent.self)?.enableAnimation(with: "Idle")
        }
    }
    
}

class EagleComponent: GKComponent, YAComponent {
    
    var hasDieAnimationFinished: Bool = false
    var didPlayDieAnimation: Bool = false
    
    func handleNewContact(_ contact: Contact) {
        guard let otherCategoryMask = contact.otherObject.colliderComponent?.categoryMask else {
            return
        }
        
        if otherCategoryMask == DemoCategoryMask.weapon || otherCategoryMask == DemoCategoryMask.projectile {
            
            if otherCategoryMask == DemoCategoryMask.projectile {
                contact.otherObject.colliderComponent?.entity?.component(ofType: HealthComponent.self)?.kill()
            }
            
            entity?.component(ofType: HealthComponent.self)?.kill()
        }
    }
    
    let dieAction = SKAction.textureAnimation(textureFormat: "eagle_die_%d",
                                              numberOfFrames: 11,
                                              timePerFrame: 0.15,
                                              loops: false,
                                              isReverse: false,
                                              textureAtlas: nil,
                                              shouldGenerateNormalMaps: true)
    
    func didSkipUpdate() {
        let isDead = entity?.component(ofType: HealthComponent.self)?.isDead
        if didPlayDieAnimation == false && isDead == true {
            didPlayDieAnimation = true
            entity?.component(ofType: SpriteNodeComponent.self)?.node.removeAllActions()
            entity?.component(ofType: SpriteNodeComponent.self)?.node.run(dieAction, completion: { [weak self] in
                self?.hasDieAnimationFinished = true
            })
        }
    }
}

extension EagleComponent: RemovalControllingComponent {
    public var canEntityBeRemoved: Bool {
        return hasDieAnimationFinished
    }
}
