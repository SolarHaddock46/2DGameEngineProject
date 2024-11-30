//
//  ProjectileShootingScene.swift
//  glide Demo
//
//  Copyright (c) 2019 cocoatoucher user on github.com (https://github.com/cocoatoucher/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import YAEngine
import SpriteKit

class ProjectileShootingScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        let touchButtonComponent = additionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)
        touchButtonComponent?.input = .profiles([(name: "Player1_Shoot", isNegative: false)])
        touchButtonComponent?.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_shoot")
        touchButtonComponent?.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_shoot_hl")
        shouldDisplayAdditionalTouchButton = true
        
        mapContact(between: DemoCategoryMask.projectile, and: GlideCategoryMask.colliderTile)
        mapContact(between: DemoCategoryMask.projectile, and: GlideCategoryMask.snappable)
        
        addEntity(playerEntity)
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let playerEntity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        
        let projectileShooterComponent = ProjectileShooterComponent(projectileTemplate: BulletEntity.self, projectilePropertiesCallback: { [weak playerEntity, weak self] in
            
            guard let playerEntity = playerEntity else { return nil }
            guard let self = self else { return nil }
            
            let kinematicsBody = playerEntity.component(ofType: KinematicsBodyComponent.self)
            let initialVelocity = kinematicsBody?.velocity ?? .zero
            
            let properties = ProjectileShootingProperties(position: playerEntity.transform.node.convert(.zero, to: self),
                                                          sourceAngle: playerEntity.transform.headingDirection == .left ? 0 : 180,
                                                          velocity: initialVelocity)
            return properties
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
    
    func setupTips() {
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 12).point(with: tileSize),
                                          text: "Use the touch button or connect a game controller (Y) to shoot projectiles. Refer to other sections for weapons.",
                                          frameWidth: 220.0)
        addEntity(tipEntity)
    }
}
