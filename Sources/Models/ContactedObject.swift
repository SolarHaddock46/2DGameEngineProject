//
//  ContactedObject.swift
//  YAEngine
//

import Foundation

/// Value that indicates different types of objects that was involed in a contact
/// or collision.
public enum ContactedObject: Equatable {
    
    /// Other object is collider component of another entity.
    case collider(ColliderComponent)
    /// Other object is a collider tile.
    case colliderTile(isEmptyTile: Bool)
    /// Other object is a slope collider tile.
    case slope(SlopeContext)
    
    public static func == (lhs: ContactedObject, rhs: ContactedObject) -> Bool {
        switch (lhs, rhs) {
        case let (.collider(lhsCollider), .collider(rhsCollider)):
            return lhsCollider === rhsCollider
        case let (.colliderTile(isLhsEmpty), .colliderTile(isRhsEmpty)):
            return isLhsEmpty == isRhsEmpty
        case let (.slope(lhsSlopeContext), .slope(rhsSlopeContext)):
            return lhsSlopeContext == rhsSlopeContext
        default:
            return false
        }
    }
    
    /// Returns collider component of the other object if the other object is an entity.
    public var colliderComponent: ColliderComponent? {
        switch self {
        case let .collider(collider):
            return collider
        default:
            return nil
        }
    }
}
