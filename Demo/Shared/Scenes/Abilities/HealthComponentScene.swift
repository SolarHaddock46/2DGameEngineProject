import YAEngine
import GameplayKit

class HealthComponentScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        mapContact(between: GlideCategoryMask.player, and: DemoCategoryMask.hazard)
        mapContact(between: GlideCategoryMask.player, and: DemoCategoryMask.npc)
        mapContact(between: DemoCategoryMask.npc, and: DemoCategoryMask.projectile)
        
        #if os(iOS)
        let touchButtonComponent = additionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)
        touchButtonComponent?.input = .profiles([(name: "Player1_Shoot", isNegative: false)])
        touchButtonComponent?.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_shoot")
        touchButtonComponent?.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_shoot_hl")
        shouldDisplayAdditionalTouchButton = true
        #elseif os(tvOS)
        Input.shared.removeInputProfilesNamed("Player1_Shoot")
        let player1ShootProfile = InputProfile(name: "Player1_Shoot") { profile in
            profile.positiveKeys = [.e, .mouseLeft, .controller1ButtonX, .controller1ButtonY]
        }
        Input.shared.addInputProfile(player1ShootProfile)
        #endif
        
        addEntity(playerEntity)
        
        // Add an array of spike entities
        let spikePositions: [TiledPoint] = [
            TiledPoint(15, 10),
            TiledPoint(17, 10),
            TiledPoint(19, 10),
            TiledPoint(36, 10),
            TiledPoint(39, 10),
            TiledPoint(55, 10),
            TiledPoint(119, 10),
            TiledPoint(152, 17),
            TiledPoint(162, 17),
            TiledPoint(175, 10),
            TiledPoint(275, 10),
            TiledPoint(339, 10)
        ]
        
        for position in spikePositions {
            let spikeEntity = SpikeEntity(initialNodePosition: position.point(with: tileSize), positionOffset: CGPoint(x: 16, y: 16))
            addEntity(spikeEntity)
        }
        
        addEntity(healthBarEntity)
        
        // Add projectile weapon entity to the scene
        addEntity(weaponEntity)
        weaponEntity.transform.parentTransform = playerEntity.transform
        weaponEntity.transform.node.zPosition = 10
        
        // Add patrolling eagle entities
        let eaglePositions: [TiledPoint] = [
            TiledPoint(27, 11),
            TiledPoint(52, 11),
            TiledPoint(83, 17),
            TiledPoint(100, 17),
            TiledPoint(136, 11),
            TiledPoint(203, 12),
            TiledPoint(207, 12),
            TiledPoint(211, 12),
            TiledPoint(222, 12),
            TiledPoint(226, 12),
            TiledPoint(306, 11),
            TiledPoint(321, 11),
            TiledPoint(334, 11)
        ]
        
        for position in eaglePositions {
            let eagleEntity = patrollingWithDisplacementNPC(at: position)
            addEntity(eagleEntity)
        }
        
        setupTips()
        
    }
    
    // MARK: - Player Entity
    
    lazy var playerEntity: GlideEntity = {
        let playerEntity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        
        let blinkerComponent = BlinkerComponent(blinkingDuration: 0.8)
        playerEntity.addComponent(blinkerComponent)
        
        let bouncerComponent = BouncerComponent(contactCategoryMasks: DemoCategoryMask.hazard)
        playerEntity.addComponent(bouncerComponent)
        
        let healthComponent = HealthComponent(maximumHealth: 3)
        playerEntity.addComponent(healthComponent)
        
        if let updatableHealthBarComponent = healthBarEntity.component(ofType: UpdatableHealthBarComponent.self) {
            let updateHealthBarComponent = UpdateHealthBarComponent(updatableHealthBarComponent: updatableHealthBarComponent)
            playerEntity.addComponent(updateHealthBarComponent)
        }
        
        let projectileShooterComponent = ProjectileShooterComponent(projectileTemplate: GrenadeEntity.self, projectilePropertiesCallback: { [weak self, weak playerEntity] in
            
            guard let playerEntity = playerEntity else { return nil }
            guard let self = self else { return nil }
            
            let weaponComponent = playerEntity.transform.componentInChildren(ofType: ProjectileWeaponComponent.self)
            if let localPosition = weaponComponent?.weaponPosition.projectileStartPosition,
                let shootingAngle = weaponComponent?.shootingAngle {
                
                let kinematicsBody = playerEntity.component(ofType: KinematicsBodyComponent.self)
                let initialVelocity = kinematicsBody?.velocity ?? .zero
                
                let properties = ProjectileShootingProperties(position: playerEntity.transform.node.convert(localPosition, to: self),
                                                              sourceAngle: shootingAngle,
                                                              velocity: initialVelocity)
                return properties
            }
            return nil
        })
        playerEntity.addComponent(projectileShooterComponent)
        
        let audioPlayerComponent = playerEntity.component(ofType: AudioPlayerComponent.self)
        
        let shootClip = AudioClip(triggerName: "Shoot",
                                  fileName: "shoot",
                                  fileExtension: "wav",
                                  loops: false,
                                  isPositional: true)
        audioPlayerComponent?.addClip(shootClip)
        
        return playerEntity
    }()
    
    // MARK: - Weapon Entity
    
    lazy var weaponEntity: GlideEntity = {
        let weaponEntity = ProjectileWeaponEntity(initialNodePosition: .zero, positionOffset: .zero)
        return weaponEntity
    }()
    
    // MARK: - Health Bar Entity
    
    lazy var healthBarEntity: HealthBarEntity = {
        return HealthBarEntity(numberOfHearts: 3)
    }()
    
    // MARK: - Patrolling Eagle Entity
    
    func patrollingWithDisplacementNPC(at position: TiledPoint) -> GlideEntity {
        let npc = EagleEntity(initialNodePosition: position.point(with: tileSize))
        
        let selfChangeDirectionComponent = SelfChangeDirectionComponent()
        let patrolArea = TiledRect(origin: position, size: TiledSize(1, 4)).rect(with: tileSize)
        
        let profile = SelfChangeDirectionComponent.Profile(condition: .patrolArea(patrolArea),
                                                           axes: .vertical,
                                                           delay: 0.0,
                                                           shouldKinematicsBodyStopOnDirectionChange: false)
        selfChangeDirectionComponent.profiles.append(profile)
        npc.addComponent(selfChangeDirectionComponent)
        
        let healthComponent = HealthComponent(maximumHealth: 1.0)
        npc.addComponent(healthComponent)
        
        return npc
    }
    
    // MARK: - Gameplay Tips
    
    func setupTips() {
        var tipWidth: CGFloat = 240.0
        var location = TiledPoint(5, 12)
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone {
            tipWidth = 200.0
        }
        #elseif os(tvOS)
        tipWidth = 300.0
        location = TiledPoint(5, 13)
        #endif
        
        let tipEntity = GameplayTipEntity(initialNodePosition: location.point(with: tileSize),
                                          text: "Avoid spikes and shoot projectiles at eagles to eliminate them.",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
    
    deinit {
        #if os(tvOS)
        Input.shared.removeInputProfilesNamed("Player1_Shoot")
        let player1ShootProfile = InputProfile(name: "Player1_Shoot") { profile in
            profile.positiveKeys = [.e, .mouseLeft, .controller1ButtonY]
        }
        Input.shared.addInputProfile(player1ShootProfile)
        #endif
    }
}
