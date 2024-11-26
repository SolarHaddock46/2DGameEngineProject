//
//  JetpackScene.swift
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

class JetpackScene: BaseLevelScene {
    
    override func setupScene() {
        super.setupScene()
        
        #if os(iOS)
        additionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.input = .profiles([(name: "Player1_Jetpack", isNegative: false)])
        shouldDisplayAdditionalTouchButton = true
        #endif
        
        addEntity(playerEntity)
        
        setupTips()
    }
    
    lazy var playerEntity: GlideEntity = {
        let playerEntity = SimplePlayerEntity(initialNodePosition: defaultPlayerStartLocation, playerIndex: 0)
        
        let jetpackComponent = JetpackOperatorComponent()
        playerEntity.addComponent(jetpackComponent)
        
        let jetpackOperatingPlayerComponent = JetpackOperatingPlayerComponent()
        playerEntity.addComponent(jetpackOperatingPlayerComponent)
        
        return playerEntity
    }()
    
    func setupTips() {
        #if os(OSX)
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 12).point(with: tileSize),
                                          text: "Use the keyboard (left ctrl) or connect a game controller (B) to enjoy the future.",
                                          frameWidth: 220.0)
        addEntity(tipEntity)
        #elseif os(iOS)
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 12).point(with: tileSize),
                                          text: "Use the touch button or connect a game controller (B) to enjoy the future.",
                                          frameWidth: 220.0)
        addEntity(tipEntity)
        #elseif os(tvOS)
        let tipEntity = GameplayTipEntity(initialNodePosition: TiledPoint(5, 13).point(with: tileSize),
                                          text: "Connect a game controller (B) to enjoy the future.",
                                          frameWidth: 300.0)
        addEntity(tipEntity)
        #endif
    }
}
