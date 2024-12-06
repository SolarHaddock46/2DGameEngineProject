//
//  BulletEntity.swift
//  glide Demo
//


import YAEngine
import GameplayKit

class BulletEntity: ProjectileTemplateEntity {
    
    let colliderSize = CGSize(width: 10, height: 8)
    
    required init(initialNodePosition: CGPoint, initialVelocity: CGVector, shootingAngle: CGFloat) {
        super.init(initialNodePosition: initialNodePosition, initialVelocity: initialVelocity, shootingAngle: shootingAngle)
        name = "Bullet"
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 12, height: 12))
        spriteNodeComponent.zPositionContainer = DemoZPositionContainer.weapons
        addComponent(spriteNodeComponent)
        
        let healthComponent = HealthComponent(maximumHealth: 1.0)
        addComponent(healthComponent)
        
        var kinematicsBodyConfiguration = KinematicsBodyComponent.sharedConfiguration
        kinematicsBodyConfiguration.maximumVerticalVelocity = 30.0
        kinematicsBodyConfiguration.maximumHorizontalVelocity = 30.0
        let kinematicsBodyComponent = KinematicsBodyComponent(configuration: kinematicsBodyConfiguration)
        addComponent(kinematicsBodyComponent)
        
        let baseVelocity: CGFloat = 12.0
        if let roundedAngle = RoundedAngle(degrees: shootingAngle) {
            spriteNodeComponent.spriteNode.texture = SKTexture(nearestFilteredImageName: "bullet_\(roundedAngle.stringValue)")
            kinematicsBodyComponent.velocity = roundedAngle.direction * baseVelocity + CGVector(dx: initialVelocity.dx, dy: 0)
        }
        
        let colliderComponent = ColliderComponent(categoryMask: DemoCategoryMask.projectile,
                                                  size: colliderSize,
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (2, 2),
                                                  rightHitPointsOffsets: (2, 2),
                                                  topHitPointsOffsets: (3, 3),
                                                  bottomHitPointsOffsets: (3, 3))
        addComponent(colliderComponent)
        
        var horizontalMovementConfiguration = HorizontalMovementComponent.sharedConfiguration
        horizontalMovementConfiguration.acceleration = 20.0
        horizontalMovementConfiguration.deceleration = 0.0
        let horizontalMovementComponent = HorizontalMovementComponent(movementStyle: .accelerated, configuration: horizontalMovementConfiguration)
        addComponent(horizontalMovementComponent)
        
        let bulletComponent = BulletComponent()
        addComponent(bulletComponent)
    }
    
}

class BulletComponent: GKComponent, YAComponent {
    
    var didPlayDieAnimation: Bool = false
    let explosionAnimationEntity = AnimationEntityFactory.explosionAnimationEntity(at: .zero)
    
    func willUpdate(deltaTime seconds: TimeInterval) {
        entity?.component(ofType: KinematicsBodyComponent.self)?.gravityInEffect = 0
    }
    
    func handleNewContact(_ contact: Contact) {
        destroyIfNeeded(contact)
    }
    
    func handleExistingContact(_ contact: Contact) {
        destroyIfNeeded(contact)
    }
    
    func destroyIfNeeded(_ contact: Contact) {
        if case .colliderTile(let isEmptyTile) = contact.otherObject, isEmptyTile == false {
            entity?.component(ofType: HealthComponent.self)?.applyDamage(1.0)
        }
    }
    
    func didSkipUpdate() {
        guard didPlayDieAnimation == false else {
            return
        }
        
        didPlayDieAnimation = true
        if let transform = transform {
            explosionAnimationEntity.transform.currentPosition = transform.node.position
            scene?.addEntity(explosionAnimationEntity)
        }
    }
}

extension BulletComponent: RemovalControllingComponent {
    public var canEntityBeRemoved: Bool {
        return didPlayDieAnimation
    }
}
