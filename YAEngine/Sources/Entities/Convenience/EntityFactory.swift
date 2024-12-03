//
//  EntityFactory.swift
//  YAEngine
//

import SpriteKit

/// Convenience functions for creating pre configured entities.
public class EntityFactory {
    
    // MARK: - Various entities
    
    /// Return a new checkpoint entity.
    ///
    /// - Parameters:
    ///     - checkpoint: Checkpoint model this entity will represent.
    ///     - checkpointWidthInTiles: Width of the entity's collider size in
    /// tile units.
    ///     - tileSize: Tile size of the scene.
    public static func checkpointEntity(checkpoint: Checkpoint,
                                        checkpointWidthInTiles: Int,
                                        tileSize: CGSize,
                                        stretchesToTop: Bool = false) -> GlideEntity {
        let entity = GlideEntity(initialNodePosition: checkpoint.bottomLeftPosition.point(with: tileSize))
        entity.name = "Checkpoint-\(checkpoint.id)"
        entity.transform.usesProposedPosition = false
        
        let checkpointComponent = CheckpointComponent(checkpoint: checkpoint, adjustsColliderSize: !stretchesToTop)
        entity.addComponent(checkpointComponent)
        
        let colliderWidth = CGFloat(checkpointWidthInTiles) * tileSize.width
        let colliderHeight = stretchesToTop ? CGFloat(checkpointWidthInTiles) * tileSize.height : 0
        let colliderComponent = ColliderComponent(categoryMask: GlideCategoryMask.snappable,
                                                  size: CGSize(width: colliderWidth, height: colliderHeight),
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (0, 0),
                                                  rightHitPointsOffsets: (0, 0),
                                                  topHitPointsOffsets: (0, 0),
                                                  bottomHitPointsOffsets: (0, 0))
        colliderComponent.isEnabled = false
        entity.addComponent(colliderComponent)
        
        let snappableComponent = SnappableComponent(providesOneWayCollision: false)
        entity.addComponent(snappableComponent)
        
        return entity
    }
    
    // MARK: - Internal
    
    static func cameraEntity(cameraNode: SKCameraNode, boundingBoxSize: CGSize) -> GlideEntity {
        let entity = GlideEntity(initialNodePosition: CGPoint.zero)
        entity.name = "MainCamera"
        
        let cameraComponent = CameraComponent(cameraNode: cameraNode, boundingBoxSize: boundingBoxSize)
        entity.addComponent(cameraComponent)
        
        return entity
    }
}
