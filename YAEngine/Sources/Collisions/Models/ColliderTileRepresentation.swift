//
//  CollisionTileRepresentation.swift
//  YAEngine
//

import SpriteKit

/// Represents a collider tile in a collision tile map.
struct ColliderTileRepresentation: Equatable {
    let tile: ColliderTile
    let userData: NSMutableDictionary?
}
