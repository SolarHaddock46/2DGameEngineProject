//
//  BaseLevelScene.swift
//  YAEngine Demo
//


import YAEngine
import SpriteKit
import GameplayKit

class BaseLevelScene: YAScene {
    
    let tileMaps: SceneTileMaps
    var defaultPlayerStartLocation: CGPoint {
        return TiledPoint(10, 10).point(with: tileSize)
    }
    
    lazy var parallaxBackgroundEntity: ParallaxBackgroundEntity = {
        let entity = ParallaxBackgroundEntity(texture: SKTexture(nearestFilteredImageName: "parallax_bg_full"),
                                              widthConstraint: .proportionalToSceneSize(1.1),
                                              heightConstraint: .proportionalToSceneSize(1.1),
                                              yOffsetConstraint: .constant(0),
                                              cameraFollowMethod: .linear(horizontalSpeed: -2.0, verticalSpeed: nil))
        return entity
    }()
    
    var inputMethodObservation: Any?
    var conversationDidStartObservation: Any?
    var conversationDidEndObservation: Any?
    var isInConversation: Bool = false
    
    required init(levelName: String, tileMaps: SceneTileMaps) {
        self.tileMaps = tileMaps
        
        super.init(collisionTileMapNode: tileMaps.collisionTileMap, zPositionContainers: DemoZPositionContainer.allCases)
    }
    
    override func setupScene() {
        
        cameraEntity.component(ofType: CameraComponent.self)?.configuration.fieldOfViewWidth = 300.0
        
        let groundBackground = tileMaps.decorationTileMaps[0]
        groundBackground.position = collisionTileMapNode?.position ?? .zero
        addChild(groundBackground, in: DemoZPositionContainer.background)
        if tileMaps.decorationTileMaps.count > 1 {
            let frontDecorationBackground = tileMaps.decorationTileMaps[1]
            frontDecorationBackground.position = collisionTileMapNode?.position ?? .zero
            addChild(frontDecorationBackground, in: DemoZPositionContainer.frontDecoration)
        }
        
        addEntity(parallaxBackgroundEntity)
        
        #if os(iOS)
        configureControls()
        
        inputMethodObservation = NotificationCenter.default.addObserver(forName: .InputMethodDidChange, object: nil, queue: nil) { [weak self] _ in
            self?.configureControls()
        }
        
        #endif
    }
    
    override func layoutOnScreenItems() {
        #if os(iOS)
        layoutTouchControls()
        #endif
    }
    
    #if os(iOS)
    lazy var moveLeftTouchButtonEntity: YAEntity = {
        let entity = YAEntity(initialNodePosition: CGPoint.zero)
        entity.name = "Move Left"
        let touchButtonComponent = TouchButtonComponent(size: CGSize(width: 120, height: 100), triggersOnTouchUpInside: false, input: .profiles([(name: "Player1_Horizontal", isNegative: true)]))
        touchButtonComponent.zPositionContainer = YAZPositionContainer.camera
        touchButtonComponent.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_moveleft")
        touchButtonComponent.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_moveleft_hl")
        entity.addComponent(touchButtonComponent)
        return entity
    }()
    lazy var moveRightTouchButtonEntity: YAEntity = {
        let entity = YAEntity(initialNodePosition: CGPoint.zero)
        entity.name = "Move Right"
        let touchButtonComponent = TouchButtonComponent(size: CGSize(width: 120, height: 100), triggersOnTouchUpInside: false, input: .profiles([(name: "Player1_Horizontal", isNegative: false)]))
        touchButtonComponent.zPositionContainer = YAZPositionContainer.camera
        touchButtonComponent.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_moveright")
        touchButtonComponent.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_moveright_hl")
        entity.addComponent(touchButtonComponent)
        return entity
    }()
    lazy var jumpTouchButtonEntity: YAEntity = {
        let entity = YAEntity(initialNodePosition: CGPoint.zero)
        entity.name = "Jump"
        let touchButtonComponent = TouchButtonComponent(size: CGSize(width: 120, height: 100), triggersOnTouchUpInside: false, input: .profiles([(name: "Player1_Jump", isNegative: false)]))
        touchButtonComponent.zPositionContainer = YAZPositionContainer.camera
        touchButtonComponent.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_jump")
        touchButtonComponent.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_jump_hl")
        entity.addComponent(touchButtonComponent)
        return entity
    }()
    
    var shouldDisplayAdditionalTouchButton: Bool = false {
        didSet {
            if shouldDisplayAdditionalTouchButton {
                if Input.shared.inputMethod.isTouchesEnabled {
                    addEntity(additionalTouchButtonEntity)
                }
            } else {
                removeEntity(additionalTouchButtonEntity)
            }
        }
    }
    
    var shouldDisplaySecondAdditionalTouchButton: Bool = false {
        didSet {
            if shouldDisplaySecondAdditionalTouchButton {
                if Input.shared.inputMethod.isTouchesEnabled {
                    addEntity(secondAdditionalTouchButtonEntity)
                }
            } else {
                removeEntity(secondAdditionalTouchButtonEntity)
            }
        }
    }
    
    lazy var additionalTouchButtonEntity: YAEntity = {
        let entity = YAEntity(initialNodePosition: CGPoint.zero)
        entity.name = "Additional Button"
        let touchButtonComponent = TouchButtonComponent(size: CGSize(width: 70, height: 100), triggersOnTouchUpInside: false, input: .callback({}))
        touchButtonComponent.zPositionContainer = YAZPositionContainer.camera
        touchButtonComponent.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_empty")
        touchButtonComponent.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_empty_hl")
        entity.addComponent(touchButtonComponent)
        return entity
    }()
    lazy var secondAdditionalTouchButtonEntity: YAEntity = {
        let entity = YAEntity(initialNodePosition: CGPoint.zero)
        entity.name = "Second Additional Button"
        let touchButtonComponent = TouchButtonComponent(size: CGSize(width: 70, height: 100), triggersOnTouchUpInside: false, input: .callback({}))
        touchButtonComponent.zPositionContainer = YAZPositionContainer.camera
        touchButtonComponent.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_empty")
        touchButtonComponent.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_empty_hl")
        entity.addComponent(touchButtonComponent)
        return entity
    }()
    lazy var pauseButtonEntity: YAEntity = {
        let entity = YAEntity(initialNodePosition: CGPoint.zero)
        entity.name = "Pause"
        let touchButtonComponent = TouchButtonComponent(size: CGSize(width: 44, height: 44),
                                                        triggersOnTouchUpInside: false,
                                                        input: .callback({ [weak self] in
                                                            self?.isPaused = true
                                                        }))
        touchButtonComponent.zPositionContainer = YAZPositionContainer.camera
        touchButtonComponent.normalTexture = SKTexture(nearestFilteredImageName: "touchbutton_pause")
        touchButtonComponent.highlightedTexture = SKTexture(nearestFilteredImageName: "touchbutton_pause_hl")
        entity.addComponent(touchButtonComponent)
        return entity
    }()
    
    func configureControls() {
        if Input.shared.inputMethod.isTouchesEnabled && isInConversation == false {
            activateTouchControls()
            layoutTouchControls()
        } else {
            deactivateTouchControls()
        }
    }
    
    func activateTouchControls() {
        addEntity(moveLeftTouchButtonEntity)
        addEntity(moveRightTouchButtonEntity)
        addEntity(jumpTouchButtonEntity)
        if shouldDisplayAdditionalTouchButton {
            addEntity(additionalTouchButtonEntity)
        }
        if shouldDisplaySecondAdditionalTouchButton {
            addEntity(secondAdditionalTouchButtonEntity)
        }
        addEntity(pauseButtonEntity)
    }
    
    func deactivateTouchControls() {
        removeEntity(moveLeftTouchButtonEntity)
        removeEntity(moveRightTouchButtonEntity)
        removeEntity(jumpTouchButtonEntity)
        removeEntity(additionalTouchButtonEntity)
        removeEntity(secondAdditionalTouchButtonEntity)
        removeEntity(pauseButtonEntity)
    }
    
    // swiftlint:disable:next function_body_length
    func layoutTouchControls() {
        if let moveLeftNode = moveLeftTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
            let nodePositionX = -size.width / 2 + moveLeftNode.size.width / 2 + 30
            let nodePositionY = -size.height / 2 + moveLeftNode.size.height / 2 + 30
            let nodePosition = CGPoint(x: nodePositionX, y: nodePositionY)
            moveLeftTouchButtonEntity.transform.proposedPosition = nodePosition
        }
        if let moveRightNode = moveRightTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
            var moveLeftShift: CGFloat = 0.0
            if let moveLeftNode = moveLeftTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
                moveLeftShift = moveLeftNode.size.width
            }
            let nodePositionX = -size.width / 2 + moveRightNode.size.width / 2 + moveLeftShift + 30
            let nodePositionY = -size.height / 2 + moveRightNode.size.height / 2 + 30
            let nodePosition = CGPoint(x: nodePositionX, y: nodePositionY)
            moveRightTouchButtonEntity.transform.proposedPosition = nodePosition
        }
        if let jumpNode = jumpTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
            
            let nodePositionX = size.width / 2 - jumpNode.size.width / 2 - 30
            let nodePositionY = -size.height / 2 + jumpNode.size.height / 2 + 30
            let nodePosition = CGPoint(x: nodePositionX, y: nodePositionY)
            jumpTouchButtonEntity.transform.proposedPosition = nodePosition
        }
        if let additionalButtonNode = additionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
            var jumpShift: CGFloat = 0.0
            if let jumpNode = jumpTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
                jumpShift = jumpNode.size.width + 20
            }
            let nodePositionX = size.width / 2 - additionalButtonNode.size.width / 2 - jumpShift - 30
            let nodePositionY = -size.height / 2 + additionalButtonNode.size.height / 2 + 30
            let nodePosition = CGPoint(x: nodePositionX, y: nodePositionY)
            additionalTouchButtonEntity.transform.proposedPosition = nodePosition
        }
        if let secondAdditionalButtonNode = secondAdditionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
            var jumpShift: CGFloat = 0.0
            if let jumpNode = jumpTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
                jumpShift = jumpNode.size.width + 20
            }
            if let additionalButtonNode = additionalTouchButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
                jumpShift += additionalButtonNode.size.width + 20
            }
            
            let nodePositionX = size.width / 2 - secondAdditionalButtonNode.size.width / 2 - jumpShift - 30
            let nodePositionY = -size.height / 2 + secondAdditionalButtonNode.size.height / 2 + 30
            let nodePosition = CGPoint(x: nodePositionX, y: nodePositionY)
            secondAdditionalTouchButtonEntity.transform.proposedPosition = nodePosition
        }
        
        if let pauseNode = pauseButtonEntity.component(ofType: TouchButtonComponent.self)?.hitBoxNode {
            
            let nodePositionX = size.width / 2 - pauseNode.size.width / 2 - 30
            let nodePositionY = size.height / 2 - pauseNode.size.height / 2 - 30
            let nodePosition = CGPoint(x: nodePositionX, y: nodePositionY)
            pauseButtonEntity.transform.proposedPosition = nodePosition
        }
    }
    #endif
    
    deinit {
        if let observation = inputMethodObservation {
            NotificationCenter.default.removeObserver(observation)
        }
        if let observation = conversationDidStartObservation {
            NotificationCenter.default.removeObserver(observation)
        }
        if let observation = conversationDidEndObservation {
            NotificationCenter.default.removeObserver(observation)
        }
    }
}
