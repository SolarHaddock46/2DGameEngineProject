//
//  Checkpoint.swift
//  YAEngine
//

/// Represents a checkpoint in a scene.
public class Checkpoint: Equatable {
    
    /// Unique identifier for the checkpoint.
    /// Duplicate identifiers are validated by a `GlideScene`.
    public let id: String
    
    /// Location category of the checkpoint.
    public let location: Location
    
    /// Bottom left position to be used for this checkpoint's entity transform in
    /// screen coordinates.
    public let bottomLeftPosition: TiledPoint
    
    /// Heading direction for the transform of an entity when it spawns from this
    /// checkpoint. Respawns are controlled by the scene.
    public let spawnDirection: TransformNodeComponent.HeadingDirection
    
    // MARK: - Initialize
    
    /// Create a checkpoint.
    ///
    /// - Parameters:
    ///     - id: Unique identifier for the checkpoint.
    /// Duplicate identifiers are validated by a `GlideScene`.
    ///     - location: Location category of the checkpoint.
    ///     - bottomLeftPosition: Bottom left position to be used for this checkpoint's
    /// entity transform in screen coordinates.
    ///     - spawnDirection: Heading direction for the transform of an entity when
    /// it spawns from this checkpoint. Respawns are controlled by the scene.
    public init(id: String,
                location: Location,
                bottomLeftPosition: TiledPoint,
                spawnDirection: TransformNodeComponent.HeadingDirection) {
        self.id = id
        self.location = location
        self.bottomLeftPosition = bottomLeftPosition
        self.spawnDirection = spawnDirection
    }
    
    public static func == (lhs: Checkpoint, rhs: Checkpoint) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Checkpoint: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Checkpoint {
    public enum Location: String {
        /// Checkpoint that is at the beginning of a scene.
        /// There can only be 1 of this type of checkpoint in a scene.
        case start
        /// Checkpoint that is in the middle of start and finish checkpoints.
        case middle
        /// Checkpoint that is at the end of a scene.
        /// There can only be 1 of this type of checkpoint in a scene.
        case finish
    }
}
