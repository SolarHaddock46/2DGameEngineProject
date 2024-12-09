//
//  ColliderTileIntersection.swift
//  YAEngine
//

import CoreGraphics

extension CollisionsController {
    
    /// Values that indicate information about an entity's collider intersection
    /// with a collision tile.
    struct ColliderTileIntersection {
        let tileRepresentation: ColliderTileRepresentation?
        let coordinates: TiledPoint
        let tileFrame: CGRect
        let intersection: CGRect
    }
}
