//
//  GlideScene+Checkpoints.swift
//  YAEngine
//

import Foundation

extension YAScene {
    
    var startCheckpoint: Checkpoint? {
        return entities.compactMap {
            $0.component(ofType: CheckpointComponent.self)?.checkpoint
            }.filter { $0.location == .start }.first
    }
    
    var finishCheckpoint: Checkpoint? {
        return entities.compactMap {
            $0.component(ofType: CheckpointComponent.self)?.checkpoint
            }.filter { $0.location == .finish }.first
    }
    
    func validateCheckpoint(_ checkpointComponent: CheckpointComponent) {
        if checkpointComponent.checkpoint.location == .start && startCheckpoint != nil {
            fatalError("Start checkpoint already added")
        }
        if checkpointComponent.checkpoint.location == .finish && finishCheckpoint != nil {
            fatalError("Finish checkpoint already added")
        }
    }
    
    func checkpoint(with checkpointId: String) -> Checkpoint? {
        return entities.compactMap {
            $0.component(ofType: CheckpointComponent.self)?.checkpoint
            }.first { $0.id == checkpointId }
    }
    
    func indexOfCheckpoint(with checkpointId: String) -> Int? {
        let checkpointEntities = entities.filter { $0.component(ofType: CheckpointComponent.self) != nil }
        return checkpointEntities.firstIndex(where: { entity -> Bool in
            entity.component(ofType: CheckpointComponent.self)?.checkpoint.id == checkpointId
        })
    }
}
