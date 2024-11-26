//
//  ColliderMovement.swift
//  YAEngine
//

import CoreGraphics

extension CollisionsController {
    
    /// Values that indicate movement information of collider component
    /// typically from one frame to another.
    struct ColliderMovement {
        let collider: ColliderComponent
        let proposedPosition: CGPoint
        let proposedObjectFrame: CGRect
        let proposedHitPoints: HitPoints
        let currentPosition: CGPoint
        let currentHitPoints: HitPoints
    }
}
