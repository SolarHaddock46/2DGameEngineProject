//
//  HealthComponentScene.swift
//
//  glide Demo
//
//  Copyright (c) 2019 cocoatoucher user on github.com (https://github.com/cocoatoucher/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import YAEngine
import GameplayKit

class HealthComponentScene: BaseLevelScene {

    override func setupScene() {
        super.setupScene()
        
        let touchButtonComponent = additionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)
        touchButtonComponent?.input = .profiles([(name: "Player1_Shoot", isNegative: false)])
        touchButtonComponent?.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_shoot")
        touchButtonComponent?.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_shoot_hl")
        shouldDisplayAdditionalTouchButton = true

        mapContact(between: GlideCategoryMask.player, and: DemoCategoryMask.hazard)

        addEntity(playerEntity)

        // Add an array of spike entities
        let spikePositions: [TiledPoint] = [
            TiledPoint(15, 10),
            TiledPoint(17, 10),
            TiledPoint(19, 10),
            // Add more positions as needed
        ]

        for position in spikePositions {
            let spikeEntity = SpikeEntity(initialNodePosition: position.point(with: tileSize), positionOffset: CGPoint(x: 16, y: 16))
            addEntity(spikeEntity)
        }

        addEntity(healthBarEntity)

        // Add melee weapon entity to the scene
        addEntity(weaponEntity)
        weaponEntity.transform.parentTransform = playerEntity.transform

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

        // Add attacking component for melee weapons
        let attackingPlayerComponent = AttackingPlayerComponent()
        playerEntity.addComponent(attackingPlayerComponent)

        return playerEntity
    }()

    // MARK: - Weapon Entity

    lazy var weaponEntity: GlideEntity = {
        let entity = MeleeWeaponEntity(initialNodePosition: .zero, playerIndex: 0)
        return entity
    }()

    // MARK: - Health Bar Entity

    lazy var healthBarEntity: HealthBarEntity = {
        return HealthBarEntity(numberOfHearts: 3)
    }()

    // MARK: - Gameplay Tips

    func setupTips() {
        #if os(OSX)
        let tipEntity = GameplayTipEntity(
            initialNodePosition: TiledPoint(5, 12).point(with: tileSize),
            text: "Use the keyboard (e) or left mouse button or connect a game controller (Y) to use the sword.",
            frameWidth: 240.0
        )
        addEntity(tipEntity)
        #elseif os(iOS)
        var tipWidth: CGFloat = 200.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            tipWidth = 180.0
        }

        let tipEntity = GameplayTipEntity(
            initialNodePosition: TiledPoint(5, 12).point(with: tileSize),
            text: "Use the touch button for the sword.",
            frameWidth: tipWidth
        )
        addEntity(tipEntity)
        #elseif os(tvOS)
        let tipEntity = GameplayTipEntity(
            initialNodePosition: TiledPoint(5, 14).point(with: tileSize),
            text: "Use (play) on remote or connect a game controller for the sword.",
            frameWidth: 350.0
        )
        addEntity(tipEntity)
        #endif
    }

    // MARK: - Deinitialization

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
