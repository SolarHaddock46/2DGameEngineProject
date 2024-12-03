//
//  CheckpointRecognizerComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that gives an entity the ability to recognize the checkpoints and save
/// them in a list upon contact.
public final class CheckpointRecognizerComponent: GKComponent, YAComponent, RespawnableEntityComponent {
    
    public static let componentPriority: Int = 650
    
    // MARK: - RespawnableEntityComponent
    
    /// Scene will ask for a new entity to be added to after this entity is removed from the scene.
    /// Provide this callback to return a new entity to be respawned.
    public var respawnedEntity: ((_ numberOfRespawnsLeft: Int) -> GlideEntity)?
    
    /// Represents the number of times this entity can be respawned from any of its recognized
    /// checkpoints.
    public internal(set) var numberOfRespawnsLeft: Int
    
    /// Provide this call back to be informed when this component's entity passes checkpoints in the scene.
    public var checkpointPassed: ((_ checkpoint: Checkpoint) -> Void)?
    
    /// List of the checkpoints in the scene that the entity has made contact with
    /// for at least once.
    public internal(set) var passedCheckpoints: [Checkpoint] = [] {
        didSet {
            let difference = passedCheckpoints.difference(from: oldValue)
            for checkpoint in difference {
                checkpointPassed?(checkpoint)
            }
        }
    }
    
    // MARK: - Initialize
    
    /// Create a checkpoint recognizer component.
    ///
    /// - Parameters:
    ///     - numberOfRespawns: Number of times that this component's entity can respawn.
    public init(numberOfRespawnsLeft: Int) {
        self.numberOfRespawnsLeft = numberOfRespawnsLeft
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
