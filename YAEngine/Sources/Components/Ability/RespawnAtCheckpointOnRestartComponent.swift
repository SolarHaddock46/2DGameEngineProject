//
//  RespawnAtCheckpointOnRestartComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that gives an entity the ability to be respawned when scene restarts
/// at its checkpoint with `checkpointId` given to this component.
public final class RespawnAtCheckpointOnRestartComponent: GKComponent, YAComponent {
    
    public static let componentPriority: Int = 610
    
    /// If index of the checkpoint that the game is restarting from is smaller than or equal
    /// to the index of the checkpoint with this id, entity will be removed and added back.
    /// That is useful for restarting game elements like enemies and collectibles that appears
    /// after a completed checkpoint when a playable character is restarting from this checkpoint.
    public let checkpointId: String
    
    /// Callback to provide the respawned entity that will be added at restart.
    public let respawnedEntity: (() -> GlideEntity)
    
    // MARK: - Initialize
    
    /// Create a checkpoint recognizer component.
    ///
    /// - Parameters:
    ///     - checkpointId: Id of the checkpoint that this component's entity belong to.
    ///     - respawnedEntity: Callback to return the respawned entity.
    public init(checkpointId: String, respawnedEntity: @escaping () -> GlideEntity) {
        self.respawnedEntity = respawnedEntity
        self.checkpointId = checkpointId
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
