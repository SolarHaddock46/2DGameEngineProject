//
//  Contact.swift
//  YAEngine
//

import Foundation
import CoreGraphics

/// Values that indicate a contact or collision between two objects.
public struct Contact {
    /// Collider of the entity that got into contact or collision.
    public let collider: ColliderComponent
    /// Other object that got into contact or collision.
    public let otherObject: ContactedObject
    /// Sides that got into contact of the collision box for the entity.
    public let contactSides: [ContactSide]
    /// Intersection frame of collision frames of the entity and other object
    /// in the coordinate space of the entity.
    public let intersection: CGRect
    /// Sides that got into contact of the collision box for the other object.
    /// That value is `nil` if the other object is not an entity.
    public let otherContactSides: [ContactSide]?
    /// Intersection frame of collision frames of the entity and other object
    /// in the coordinate space of the other object.
    /// That value is `nil` if the other object is not an entity.
    public let otherIntersection: CGRect?
}
