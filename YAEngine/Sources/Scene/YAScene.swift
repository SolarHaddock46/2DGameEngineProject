//
//  GlideScene+Contacts.swift
//  YAEngine
//

import GameplayKit
import SpriteKit

/// Base scene class
open class YAScene: SKScene {
    
    public weak var yaSceneDelegate: YASceneDelegate?
    
    /// Tile map node that is populated with collider tiles.
    /// See `ColliderTile` for more information on recognized collider tile definitions.
    public let collisionTileMapNode: SKTileMapNode?
    
    public var tileSize: CGSize {
        return collisionTileMapNode?.tileSize ?? .zero
    }
    
    /// Definitions for container nodes that will be created in the scene.
    /// Order container node with a lower index in this array has a lower `zPosition`
    /// which means it is farther from the camera of a scene.
    public let zPositionContainers: [ZPositionContainer]
    
    /// Entity controlling the camera node of the scene.
    public lazy var cameraEntity: YAEntity = {
        let cameraNode = SKCameraNode()
        camera = cameraNode
        let entity = EntityFactory.cameraEntity(cameraNode: cameraNode, boundingBoxSize: collisionTileMapNode?.mapSize ?? size)
        entity.name = zPositionContainerNodeName(YAZPositionContainer.camera)
        entity.transform.node.zPosition = CGFloat.greatestFiniteMagnitude
        entity.transform.usesProposedPosition = false
        entity.transform.node.addChild(cameraNode)
        return entity
    }()
    
    /// Entity with `FocusableEntitiesControllerComponent` of the scene.
    public lazy var focusableEntitiesControllerEntity: YAEntity = {
        let entity = YAEntity(initialNodePosition: CGPoint.zero)
        let focusableEntitiesController = FocusableEntitiesControllerComponent()
        entity.addComponent(focusableEntitiesController)
        return entity
    }()
    
    /// `true` if this scene should be paused when the app goes to background.
    public var shouldPauseWhenAppIsInBackground: Bool = true
    
    open override var isPaused: Bool {
        willSet {
            #if os(OSX)
            if isPaused && newValue == false {
                NSApp.keyWindow?.makeFirstResponder(self.view)
            }
            #endif
        }
        didSet {
            Input.shared.flushInputs()
            if isPaused {
                wasPaused = true
            }
            
            DispatchQueue.main.async {
                self.yaSceneDelegate?.yaScene(self, didChangePaused: self.isPaused)
            }
        }
    }
    
    // MARK: - Initialize
    
    /// Create a scene.
    ///
    /// - Parameters:
    ///     - collisionTileMapNode: Tile map node that is populated with collidable tiles.
    /// See `ColliderTile` for more information on recognized collider tile definitions.
    ///     - zPositionContainers: Definitions for container nodes that will be created in the scene.
    public init(collisionTileMapNode: SKTileMapNode?,
                zPositionContainers: [ZPositionContainer]) {
        
        ComponentPriorityRegistry.shared.initializeIfNeeded()
        self.zPositionContainers = zPositionContainers
        self.collisionTileMapNode = collisionTileMapNode
        
        var tileMapRepresentation: CollisionTileMapRepresentation?
        if let collisionTileMapNode = collisionTileMapNode {
            tileMapRepresentation = CollisionTileMapRepresentation(tileMap: collisionTileMapNode)
        }
        self.collisionsController = CollisionsController(tileMapRepresentation: tileMapRepresentation)
        
        super.init(size: .zero)
        
        constructZPositionContainerNodes()
        registerForNotifications()
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    var previousSceneSize: CGSize = .zero
    var didInitialize: Bool = false
    
    var currentTime: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    
    var wasPaused: Bool = false
    
    var entities: [YAEntity] = []
    var entitiesSnapshot: [YAEntity] = []
    var internalEntities: [YAEntity] = []
    
    let collisionsController: CollisionsController
    var contactTestMap: [UInt32: UInt32] = [:]
    
    var checkpointIdsAndRespawnCallbacks: [(String, () -> YAEntity)] = []
    
    lazy var defaultContainerNode: SKNode = {
        let node = SKNode()
        node.name = zPositionContainerNodeName(YAZPositionContainer.default)
        return node
    }()
    
    #if DEBUG
    lazy var debugContainerNode: SKNode = {
        let node = SKNode()
        node.name = zPositionContainerNodeName(YAZPositionContainer.debug)
        return node
    }()
    
    /// Whether the collision tile map should be drawn or not.
    /// Default value is `false`.
    /// Compiler `DEBUG` flag should on for this to work.
    /// A texture atlas for collision tiles should be provided
    /// for loading collider tile map from a Tiled Map Editor file.
    public var isDebuggingCollisionTileMapNode: Bool = false {
        didSet {
            updateCollisionTileMapNodeDebug()
        }
    }
    #endif
    
    private var appWillResignActiveObservation: Any?
    private var appDidBecomeActiveObservation: Any?
    
    private func registerForNotifications() {
        appWillResignActiveObservation = NotificationCenter.default.addObserver(forName: Application.willResignActiveNotification,
                                                                                object: nil,
                                                                                queue: nil) { [weak self] _ in
                                                                                    guard self?.shouldPauseWhenAppIsInBackground == true else {
                                                                                        return
                                                                                    }
                                                                                    self?.isPaused = true
        }
        
        // Pausing also in app did become active, because on iOS, scene is automatically set
        // to `isPaused` = `false` when the app becomes active.
        appDidBecomeActiveObservation = NotificationCenter.default.addObserver(forName: Application.didBecomeActiveNotification,
                                                                               object: nil,
                                                                               queue: nil) { [weak self] _ in
                                                                                guard self?.shouldPauseWhenAppIsInBackground == true else {
                                                                                    return
                                                                                }
                                                                                self?.isPaused = true
        }
    }
    
    func respawnRemovedEntities(removedEntities: [YAEntity]) -> (isAnyPlayableEntityRespawned: Bool, indexOfLastCheckpointReached: Int) {
        var indexOfLastCheckpointReached: Int = 0
        var isAnyPlayableEntityRespawned = false
        for removedEntity in removedEntities {
            
            let respawnableEntityComponent = removedEntity.components.first { $0 is RespawnableEntityComponent } as? RespawnableEntityComponent
            
            guard let numberOfRespawnsLeft = respawnableEntityComponent?.numberOfRespawnsLeft else {
                continue
            }
            
            guard numberOfRespawnsLeft > 0 else {
                continue
            }
            
            if let respawned = respawnableEntityComponent?.respawnedEntity?(numberOfRespawnsLeft) {
                
                let lastPassedCheckpoint = removedEntity.component(ofType: CheckpointRecognizerComponent.self)?.passedCheckpoints.last
                
                if
                    removedEntity.component(ofType: PlayableCharacterComponent.self) != nil,
                    let lastPassedCheckpoint = lastPassedCheckpoint
                {
                    isAnyPlayableEntityRespawned = true
                    
                    if let checkpointIndex = indexOfCheckpoint(with: lastPassedCheckpoint.id) {
                        indexOfLastCheckpointReached = max(checkpointIndex, indexOfLastCheckpointReached)
                    }
                }
                
                addEntity(respawned)
                respawned.component(ofType: CheckpointRecognizerComponent.self)?.numberOfRespawnsLeft = numberOfRespawnsLeft - 1
            }
        }
        
        return (isAnyPlayableEntityRespawned, indexOfLastCheckpointReached)
    }
    
    func respawnEntitiesWithRestartCheckpointIndexGreaterThan(checkpointIndex: Int) {
        for entity in entities {
            if let restartComponent = entity.component(ofType: RespawnAtCheckpointOnRestartComponent.self) {
                if let indexOfEntityCheckpoint = indexOfCheckpoint(with: restartComponent.checkpointId) {
                    if indexOfEntityCheckpoint >= checkpointIndex {
                        removeEntity(entity)
                    }
                }
            }
        }
        
        let callbacksCopy = checkpointIdsAndRespawnCallbacks
        checkpointIdsAndRespawnCallbacks = []
        
        for callback in callbacksCopy {
            if let indexOfEntityCheckpoint = indexOfCheckpoint(with: callback.0) {
                if indexOfEntityCheckpoint >= checkpointIndex {
                    let respawnedEntity = callback.1()
                    addEntity(respawnedEntity)
                }
            }
        }
    }
    
    #if DEBUG
    func updateCollisionTileMapNodeDebug() {
        guard let collisionTileMapNode = collisionTileMapNode else {
            return
        }
        
        if isDebuggingCollisionTileMapNode {
            if collisionTileMapNode.parent == nil {
                zPositionContainerNode(with: YAZPositionContainer.debug)?.addChild(collisionTileMapNode)
            }
        } else {
            collisionTileMapNode.removeFromParent()
        }
    }
    #endif
    
    deinit {
        if let observation = appWillResignActiveObservation {
            NotificationCenter.default.removeObserver(observation)
        }
        if let observation = appDidBecomeActiveObservation {
            NotificationCenter.default.removeObserver(observation)
        }
    }
}
