//
//  ContactContext.swift
//  YAEngine
//

import CoreGraphics

/// Values that indicate detailed information about a contact.
struct ContactContext: Equatable {
    let collider: ColliderComponent
    let otherObject: ContactedObject
    var isCollision: Bool
    let colliderContactSides: [ContactSide]
    let colliderIntersection: CGRect
    var otherObjectContactSides: [ContactSide]
    var otherObjectIntersection: CGRect
    var proposedPosition: CGPoint
    
    func controllerAVerticalContactSide() -> ContactSide? {
        return colliderContactSides.filter { $0 == .bottom || $0 == .top }.first
    }
    
    var isUnspecified: Bool {
        return colliderContactSides.contains(.unspecified)
    }
    
    var contactForCollider: Contact {
        return Contact(collider: collider,
                       otherObject: otherObject,
                       contactSides: colliderContactSides,
                       intersection: colliderIntersection,
                       otherContactSides: otherObjectContactSides,
                       otherIntersection: otherObjectIntersection)
    }
    
    var contactForOtherObject: Contact? {
        guard let otherCollider = otherObject.colliderComponent else {
            return nil
        }
        return Contact(collider: otherCollider,
                       otherObject: .collider(collider),
                       contactSides: otherObjectContactSides,
                       intersection: otherObjectIntersection,
                       otherContactSides: colliderContactSides,
                       otherIntersection: colliderIntersection)
    }
    
    static func == (lhs: ContactContext, rhs: ContactContext) -> Bool {
        return
            lhs.collider === rhs.collider &&
                lhs.otherObject == rhs.otherObject &&
                lhs.isCollision == rhs.isCollision
    }
}

extension ContactContext {
    struct ContactSideAndOffset: Equatable {
        let contactSide: ContactSide
        let offset: CGFloat
        
        static func == (lhs: ContactSideAndOffset, rhs: ContactSideAndOffset) -> Bool {
            return lhs.contactSide == rhs.contactSide && lhs.offset == rhs.offset
        }
    }
}
