import YAEngine
import GameplayKit

class Level11: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        mapContact(between: YACategoryMask.player, and: DemoCategoryMask.hazard)
        mapContact(between: YACategoryMask.player, and: DemoCategoryMask.npc)
        mapContact(between: DemoCategoryMask.npc, and: DemoCategoryMask.projectile)
        mapContact(between: YACategoryMask.player, and: DemoCategoryMask.collectible)
        
        let touchButtonComponent = additionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)
        touchButtonComponent?.input = .profiles([(name: "Player1_Shoot", isNegative: false)])
        touchButtonComponent?.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_shoot")
        touchButtonComponent?.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_shoot_hl")
        shouldDisplayAdditionalTouchButton = true
        
        addEntity(playerEntity)
        
        // Spike positions
        let spikePositions: [TiledPoint] = [
            TiledPoint(15, 10),
            TiledPoint(36, 10),
            TiledPoint(55, 10),
            TiledPoint(119, 10),
            TiledPoint(152, 17),
            TiledPoint(175, 10),
            TiledPoint(275, 10),
            TiledPoint(339, 10)
        ]
        
        for position in spikePositions {
            let spikeEntity = SpikeEntity(initialNodePosition: position.point(with: tileSize), positionOffset: CGPoint(x: 16, y: 16))
            addEntity(spikeEntity)
        }
        
        addEntity(healthBarEntity)
        
        // Projectile weapon entity
        addEntity(weaponEntity)
        weaponEntity.transform.parentTransform = playerEntity.transform
        weaponEntity.transform.node.zPosition = 10
        
        // Patrolling eagle entities
        let eaglePositions: [TiledPoint] = [
            TiledPoint(52, 11),
            TiledPoint(83, 17),
            TiledPoint(100, 17),
            TiledPoint(136, 20),
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
        
        // Gem entities
        let gemPositions: [TiledPoint] = [
            TiledPoint(30, 10),
            TiledPoint(34, 18),
            TiledPoint(35, 15),
            TiledPoint(62, 13),
            TiledPoint(95, 15),
            TiledPoint(106, 15),
            TiledPoint(115, 10),
            TiledPoint(152, 21),
            TiledPoint(155, 21),
            TiledPoint(213, 11),
            TiledPoint(200, 2),
            TiledPoint(202, 2),
            TiledPoint(204, 2),
            TiledPoint(206, 2),
            TiledPoint(208, 2),
            TiledPoint(210, 2),
            TiledPoint(212, 2),
            TiledPoint(261, 11),
            TiledPoint(285, 10)
        ]
        
        for position in gemPositions {
            let gemEntity = GemEntity(bottomLeftPosition: position.point(with: tileSize))
            addEntity(gemEntity)
        }
        
        addEntity(gemCounterEntity)
        
        setupTips()
        
        if let backgroundMusicComponent = playerEntity.component(ofType: BackgroundMusicComponent.self) {
            backgroundMusicComponent.setBackgroundMusic(fileName: "bgm", fileExtension: "mp3")
            backgroundMusicComponent.playBackgroundMusic()
        }
    }
    
    // MARK: - Player Entity
    
    lazy var playerEntity: YAEntity = {
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
        
        let updateGemCounterComponent = UpdateGemCounterComponent(gemCounterEntity: gemCounterEntity)
        playerEntity.addComponent(updateGemCounterComponent)
        
        let backgroundMusicComponent = BackgroundMusicComponent()
        playerEntity.addComponent(backgroundMusicComponent)
        
        return playerEntity
    }()
    
    // MARK: - Weapon Entity
    
    lazy var weaponEntity: YAEntity = {
        let weaponEntity = ProjectileWeaponEntity(initialNodePosition: .zero, positionOffset: .zero)
        return weaponEntity
    }()
    
    // MARK: - Health Bar Entity
    
    lazy var healthBarEntity: HealthBarEntity = {
        return HealthBarEntity(numberOfHearts: 3)
    }()
    
    // MARK: - Gem Counter Entity
    
    var gemCounterEntity = GemCounterEntity(initialNodePosition: .zero)
    
    // MARK: - Patrolling Eagle Entity
    
    func patrollingWithDisplacementNPC(at position: TiledPoint) -> YAEntity {
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
        if UIDevice.current.userInterfaceIdiom == .phone {
            tipWidth = 200.0
        }
        
        let tipEntity = GameplayTipEntity(initialNodePosition: location.point(with: tileSize),
                                          text: "Avoid spikes and shoot projectiles at eagles to eliminate them. Collect gems to increase your score!",
                                          frameWidth: tipWidth)
        addEntity(tipEntity)
    }
}
