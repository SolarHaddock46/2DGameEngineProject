//
//  SKTileMapNode+TileRepresentations.swift
//  YAEngine
//

import SpriteKit

extension SKTileMapNode {
    
    /// Values that represent this tile map node in the model level.
    /// Outer array contains columns of tiles, and inner array contains rows of tiles for that column.
    var tileRepresentations: [[ColliderTileRepresentation?]] {
        var result = [[ColliderTileRepresentation?]]()
        for column in 0 ..< numberOfColumns {
            var tileRepresentationsForColumn = [ColliderTileRepresentation?]()
            for row in 0 ..< numberOfRows {
                let tileDefinition = self.tileDefinition(atColumn: column, row: row)
                if let tileName = tileDefinition?.name, let tile = ColliderTile(tileName) {
                    let representation = ColliderTileRepresentation(tile: tile, userData: tileDefinition?.userData)
                    tileRepresentationsForColumn.append(representation)
                } else {
                    tileRepresentationsForColumn.append(nil)
                }
            }
            result.append(tileRepresentationsForColumn)
        }
        return result
    }
}
