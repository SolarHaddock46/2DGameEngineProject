//
//  TileMaps.swift
//  YAEngine
//

import SpriteKit

/// Collision and decoration tile maps to be provided for a `GlideScene`.
/// This is typically populated with loaded information from a level file
/// either a .sks file from `SpriteKit`, or .json map file from `Tiled Map Editor`.
public struct SceneTileMaps {
    
    /// Tile map that contains collidable tiles.
    public let collisionTileMap: SKTileMapNode
    /// Tile maps that is drawn for decoration purposes.
    public let decorationTileMaps: [SKTileMapNode]
    
    // MARK: - Initialize
    
    /// Create a scene tile maps.
    ///
    /// - Parameters:
    ///     - collisionTileMap: Tile map that contains collidable tiles.
    ///     - decorationTileMaps: Tile maps that is drawn for decoration purposes.
    public init(collisionTileMap: SKTileMapNode, decorationTileMaps: [SKTileMapNode]) {
        self.collisionTileMap = collisionTileMap
        self.decorationTileMaps = decorationTileMaps
    }
}
