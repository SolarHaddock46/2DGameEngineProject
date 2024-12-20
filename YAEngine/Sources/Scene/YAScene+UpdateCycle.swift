//
//  GlideScene+UpdateCycle.swift
//  YAEngine
//

import SpriteKit

extension YAScene {
    
    open override func sceneDidLoad() {
        super.sceneDidLoad()
        
        if let collisionTileMapNode = collisionTileMapNode {
            collisionTileMapNode.position = CGPoint(x: collisionTileMapNode.mapSize.width / 2,
                                                    y: collisionTileMapNode.mapSize.height / 2)
        }
        
        scene?.addChild(defaultContainerNode)
        
        #if DEBUG
        scene?.addChild(debugContainerNode)
        debugContainerNode.zPosition = CGFloat.greatestFiniteMagnitude - 1000
        updateCollisionTileMapNodeDebug()
        #endif
        
        addEntity(focusableEntitiesControllerEntity)
        
        addChild(cameraEntity.transform.node)
        
        internalEntities = [focusableEntitiesControllerEntity, cameraEntity]
    }
    
    open override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        initializeIfNeeded()
    }
    
    /// Point for adding your initial entities to the scene. Called before the
    /// update loop starts.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    @objc open func setupScene() { }
    
    private func initializeIfNeeded() {
        if didInitialize == false {
            didInitialize = true
            
            setupScene()
            initializeCamera()
        }
    }
    
    private func initializeCamera() {
        cameraEntity.internal_didMoveToScene(self)
        cameraEntity.internal_layout(scene: self, previousSceneSize: size)
        
        let cameraComponent = cameraEntity.component(ofType: CameraComponent.self)
        let playableTransforms = entities.filter {
            $0.component(ofType: PlayableCharacterComponent.self) != nil
            }.map { $0.transform }
        cameraComponent?.setCameraPosition(to: playableTransforms)
    }
    
    open override func didChangeSize(_ oldSize: CGSize) {
        if collisionTileMapNode == nil {
            cameraEntity.component(ofType: CameraComponent.self)?.boundingBoxSize = size
        }
        layoutOnScreenItems()
    }
    
    /// Called each time scene size changes.
    /// Implementation of `super` does nothing.
    /// Don't call this method directly.
    @objc open func layoutOnScreenItems() { }
    
    open override func update(_ currentTime: TimeInterval) {
        self.currentTime = currentTime
        
        Input.shared.update()
        
        if Input.shared.isButtonPressed("Pause") {
            isPaused = !isPaused
            return
        }
        
        if wasPaused {
            lastUpdateTime = currentTime
            wasPaused = false
        }
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        
        let deltaTime = currentTime - lastUpdateTime
        
        entitiesSnapshot = entities
        
        updateEntities(currentTime: currentTime, deltaTime: deltaTime)
        
        resolveCollisionsAndNotifyContacts()
        
        updateEntityPositions()
        
        updateCamera(currentTime: currentTime, deltaTime: deltaTime)
        
        updateEntitiesAfterCameraUpdate(deltaTime: deltaTime)
        
        layoutEntitiesIfNeeded()
    }
    
    private func updateEntities(currentTime: TimeInterval, deltaTime: TimeInterval) {
        let entitiesToUpdate = entitiesSnapshot.filter {
            guard $0.shouldBeUpdated else {
                return false
            }
            guard isEntityInSight($0) else {
                return false
            }
            return true
        }.sorted { (left, right) -> Bool in
            if left.component(ofType: SnappableComponent.self) != nil {
                return true
            } else if right.component(ofType: SnappableComponent.self) != nil {
                return false
            }
            return true
        }
        
        let snappables = entitiesToUpdate.filter { $0.component(ofType: SnappableComponent.self) != nil }
        snappables.forEach {
            $0.internal_update(currentTime: currentTime, deltaTime: currentTime - lastUpdateTime)
        }
        let nonSnappables = entitiesToUpdate.filter { $0.component(ofType: SnappableComponent.self) == nil }
        
        nonSnappables.forEach {
            $0.internal_update(currentTime: currentTime, deltaTime: currentTime - lastUpdateTime)
        }
        
        entitiesSnapshot.forEach {
            if entitiesToUpdate.contains($0) == false {
                $0.internal_didSkipUpdate()
            } else {
                $0.internal_resetStates(currentTime: currentTime, deltaTime: deltaTime)
            }
        }
    }
    
    private func resolveCollisionsAndNotifyContacts() {
        let allEntitiesToUpdate = entitiesSnapshot.filter {
            guard $0.shouldBeUpdated else {
                return false
            }
            guard isEntityInSight($0) else {
                return false
            }
            return true
        }
        collisionsController.update(entities: allEntitiesToUpdate)
        notifyContacts()
        collisionsController.resetContacts()
    }
    
    private func notifyContacts() {
        notifyEnteredAndStayedContacts()
        notifyExitedContacts()
    }
    
    private func updateEntityPositions() {
        entitiesSnapshot.forEach {
            guard $0.shouldBeUpdated else {
                return
            }
            guard $0.transform.usesProposedPosition else {
                return
            }
            guard isEntityInSight($0) else {
                return
            }
            $0.transform.updateNodePosition($0.transform.proposedPosition)
        }
    }
    
    private func updateCamera(currentTime: TimeInterval, deltaTime: TimeInterval) {
        let cameraComponent = cameraEntity.component(ofType: CameraComponent.self)
        
        let focusTransformsForCamera = entitiesSnapshot.filter {
            $0.isCameraFocusable
        }.map { $0.transform }
        cameraComponent?.focusTransforms = focusTransformsForCamera
        cameraEntity.internal_update(currentTime: currentTime, deltaTime: deltaTime)
        cameraEntity.internal_resetStates(currentTime: currentTime, deltaTime: deltaTime)
    }
    
    private func updateEntitiesAfterCameraUpdate(deltaTime: TimeInterval) {
        guard let cameraComponent = cameraEntity.component(ofType: CameraComponent.self) else {
            return
        }
        
        entitiesSnapshot.forEach {
            guard $0.shouldBeUpdated else {
                return
            }
            guard isEntityInSight($0) else {
                return
            }
            
            $0.internal_updateAfterCameraUpdate(deltaTime: deltaTime, cameraComponent: cameraComponent)
        }
    }
    
    private func layoutEntitiesIfNeeded() {
        (entitiesSnapshot + [cameraEntity]).forEach {
            guard isEntityInSight($0) else {
                return
            }
            
            $0.internal_layout(scene: self, previousSceneSize: previousSceneSize)
        }
    }
    
    open override func didEvaluateActions() {
        let entitiesToEvaluateActions = entitiesSnapshot.filter {
            guard $0.shouldBeUpdated else {
                return false
            }
            guard isEntityInSight($0) else {
                return false
            }
            return true
        }
        
        entitiesToEvaluateActions.forEach {
            $0.internal_sceneDidEvaluateActions()
        }
    }
    
    open override func didFinishUpdate() {
        let entitiesToFinishUpdate = entitiesSnapshot.filter {
            guard isEntityInSight($0) else {
                return false
            }
            return true
        }
        
        entitiesToFinishUpdate.forEach {
            $0.internal_didFinishUpdate()
        }
        
        finish()
    }
    
    private func finish() {
        let removedEntities = cleanUpEntities()
        
        respawnEntities(removedEntities: removedEntities)
        
        Input.shared.reset()
        
        previousSceneSize = size
        
        lastUpdateTime = currentTime
    }
    
    private func cleanUpEntities() -> [YAEntity] {
        var removedEntities: [YAEntity] = []
        entitiesSnapshot.filter { $0.canBeRemoved && entities.contains($0) }.forEach { entityToBeRemoved in
            
            if let removedEntity = finishEntity(entityToBeRemoved,
                                                killIfPossible: false) {
                removedEntities.append(removedEntity)
            }
        }
        
        collisionsController.cleanReferencedComponents()
        
        return removedEntities
    }
    
    private func respawnEntities(removedEntities: [YAEntity]) {
        
        let respawnResult = respawnRemovedEntities(removedEntities: removedEntities)
        
        let playableEntities = entitiesSnapshot.filter {
            $0.component(ofType: PlayableCharacterComponent.self) != nil
        }
        guard playableEntities.isEmpty == false else {
            endScene(reason: .hasNoMorePlayableEntities)
            return
        }
        
        if respawnResult.isAnyPlayableEntityRespawned {
            respawnEntitiesWithRestartCheckpointIndexGreaterThan(checkpointIndex: respawnResult.indexOfLastCheckpointReached)
        }
    }
    
}
