//
//  CollisionsController+ContactSides.swift
//  YAEngine
//

import CoreGraphics
import Foundation

extension CollisionsController {
    func topContactSides(intersection: CGRect,
                         hitPointsOffsets: (left: CGFloat, right: CGFloat),
                         currentHitPoints: HitPoints,
                         proposedHitPoints: HitPoints,
                         otherObjectFrame: CGRect) -> [ContactContext.ContactSideAndOffset] {
        var result: [ContactContext.ContactSideAndOffset] = []
        if intersection.intersects(proposedHitPoints.top.left) {
            if currentHitPoints.top.left.maxY <= otherObjectFrame.minY {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .top,
                                                                               offset: -intersection.height)
                result.append(contactSideAndOffset)
            } else if currentHitPoints.top.left.minX >= otherObjectFrame.maxX {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .left,
                                                                               offset: intersection.width - hitPointsOffsets.left)
                result.append(contactSideAndOffset)
            }
        }
        if intersection.intersects(proposedHitPoints.top.right) {
            if currentHitPoints.top.right.maxY <= otherObjectFrame.minY {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .top,
                                                                               offset: -intersection.height)
                result.append(contactSideAndOffset)
            } else if currentHitPoints.top.right.maxX <= otherObjectFrame.minX {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .right,
                                                                               offset: -(intersection.width - hitPointsOffsets.right))
                result.append(contactSideAndOffset)
            }
        }
        
        return result
    }
    
    func bottomContactSides(intersection: CGRect,
                            wasOnSlope: Bool,
                            hitPointsOffsets: (left: CGFloat, right: CGFloat),
                            currentHitPoints: HitPoints,
                            proposedHitPoints: HitPoints,
                            otherObjectFrame: CGRect) -> [ContactContext.ContactSideAndOffset] {
        var result: [ContactContext.ContactSideAndOffset] = []
        if intersection.intersects(proposedHitPoints.bottom.left) {
            if currentHitPoints.bottom.left.minY >= otherObjectFrame.maxY ||
                wasOnSlope {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .bottom,
                                                                               offset: intersection.height)
                result.append(contactSideAndOffset)
            } else if currentHitPoints.bottom.left.minX >= otherObjectFrame.maxX {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .left,
                                                                               offset: intersection.width - hitPointsOffsets.left)
                result.append(contactSideAndOffset)
            }
        }
        if intersection.intersects(proposedHitPoints.bottom.right) {
            if currentHitPoints.bottom.right.minY >= otherObjectFrame.maxY ||
                wasOnSlope {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .bottom,
                                                                               offset: intersection.height)
                result.append(contactSideAndOffset)
            } else if currentHitPoints.bottom.right.maxX <= otherObjectFrame.minX {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .right,
                                                                               offset: -(intersection.width - hitPointsOffsets.right))
                result.append(contactSideAndOffset)
            }
        }
        return result
    }
    
    func leftContactSides(intersection: CGRect,
                          hitPointsOffsets: (bottom: CGFloat, top: CGFloat),
                          currentHitPoints: HitPoints,
                          proposedHitPoints: HitPoints,
                          colliderContactsBottom: Bool,
                          otherObjectFrame: CGRect) -> [ContactContext.ContactSideAndOffset] {
        var result: [ContactContext.ContactSideAndOffset] = []
        if intersection.intersects(proposedHitPoints.left.top) {
            if currentHitPoints.left.top.minX >= otherObjectFrame.maxX {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .left,
                                                                               offset: intersection.width)
                result.append(contactSideAndOffset)
            } else if currentHitPoints.left.top.maxY <= otherObjectFrame.minY {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .top,
                                                                               offset: -(intersection.height - hitPointsOffsets.top))
                result.append(contactSideAndOffset)
            }
        }
        if intersection.intersects(proposedHitPoints.left.bottom) {
            if currentHitPoints.left.bottom.minX >= otherObjectFrame.maxX {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .left,
                                                                               offset: intersection.width)
                result.append(contactSideAndOffset)
            } else if
                currentHitPoints.left.bottom.minY >= otherObjectFrame.maxY &&
                    colliderContactsBottom == false {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .left,
                                                                               offset: intersection.width)
                result.append(contactSideAndOffset)
            }
        }
        return result
    }
    
    func rightContactSides(intersection: CGRect,
                           hitPointsOffsets: (bottom: CGFloat, top: CGFloat),
                           currentHitPoints: HitPoints,
                           proposedHitPoints: HitPoints,
                           colliderContactsBottom: Bool,
                           otherObjectFrame: CGRect) -> [ContactContext.ContactSideAndOffset] {
        var result: [ContactContext.ContactSideAndOffset] = []
        if intersection.intersects(proposedHitPoints.right.top) {
            if currentHitPoints.right.top.maxX <= otherObjectFrame.minX {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .right,
                                                                               offset: -intersection.width)
                result.append(contactSideAndOffset)
            } else if currentHitPoints.right.top.maxY <= otherObjectFrame.minY {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .top,
                                                                               offset: -(intersection.height - hitPointsOffsets.top))
                result.append(contactSideAndOffset)
            }
        }
        if intersection.intersects(proposedHitPoints.right.bottom) {
            if currentHitPoints.right.bottom.maxX <= otherObjectFrame.minX {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .right,
                                                                               offset: -intersection.width)
                result.append(contactSideAndOffset)
            } else if
                currentHitPoints.right.bottom.minY >= otherObjectFrame.maxY &&
                    colliderContactsBottom == false {
                let contactSideAndOffset = ContactContext.ContactSideAndOffset(contactSide: .right,
                                                                               offset: -intersection.width)
                result.append(contactSideAndOffset)
            }
        }
        return result
    }
    
    func contactSideWithMaxOffset(on side: ContactSide,
                                  within contactSidesAndOffsets: [ContactContext.ContactSideAndOffset]) -> ContactContext.ContactSideAndOffset? {
        return contactSidesAndOffsets.filter { $0.contactSide == side }.max { leftContactSide, rightContactSide -> Bool in
            abs(leftContactSide.offset) < abs(rightContactSide.offset)
        }
    }
    
    func filteredContactSidesAndOffsets(from contactSidesAndOffsets: [ContactContext.ContactSideAndOffset]) -> [ContactContext.ContactSideAndOffset] {
        var result: [ContactContext.ContactSideAndOffset] = []
        
        for contactSide in ContactSide.allCases {
            if let filtered = contactSideWithMaxOffset(on: contactSide, within: contactSidesAndOffsets) {
                result.append(filtered)
            }
        }
        
        return result
    }
    
    func contactSides(for collider: ColliderComponent,
                      currentPosition: CGPoint,
                      proposedPosition: CGPoint,
                      currentHitPoints: HitPoints,
                      proposedHitPoints: HitPoints,
                      intersection: CGRect,
                      otherObjectFrame: CGRect,
                      proposedOtherObjectFrame: CGRect) -> [ContactContext.ContactSideAndOffset] {
        var result: [ContactContext.ContactSideAndOffset] = []
        
        let topContactSides = self.topContactSides(intersection: intersection,
                                                   hitPointsOffsets: collider.topHitPointsOffsets,
                                                   currentHitPoints: currentHitPoints,
                                                   proposedHitPoints: proposedHitPoints,
                                                   otherObjectFrame: otherObjectFrame)
        result.append(contentsOf: topContactSides)
        
        let bottomContactSides = self.bottomContactSides(intersection: intersection,
                                                         wasOnSlope: collider.wasOnSlope,
                                                         hitPointsOffsets: collider.bottomHitPointsOffsets,
                                                         currentHitPoints: currentHitPoints,
                                                         proposedHitPoints: proposedHitPoints,
                                                         otherObjectFrame: otherObjectFrame)
        result.append(contentsOf: bottomContactSides)
        
        let colliderContactsBottom = result.contains(where: { $0.contactSide == .bottom })
        
        let leftContactSides = self.leftContactSides(
            intersection: intersection,
            hitPointsOffsets: collider.leftHitPointsOffsets,
            currentHitPoints: currentHitPoints,
            proposedHitPoints: proposedHitPoints,
            colliderContactsBottom: colliderContactsBottom,
            otherObjectFrame: otherObjectFrame
        )
        result.append(contentsOf: leftContactSides)
        
        let rightContactSides = self.rightContactSides(
            intersection: intersection,
            hitPointsOffsets: collider.rightHitPointsOffsets,
            currentHitPoints: currentHitPoints,
            proposedHitPoints: proposedHitPoints,
            colliderContactsBottom: colliderContactsBottom,
            otherObjectFrame: otherObjectFrame
        )
        result.append(contentsOf: rightContactSides)
        
        return filteredContactSidesAndOffsets(from: result)
    }
    
    // MARK: - Convenience
    
    func contactSides(for colliderMovement: ColliderMovement,
                      intersection: CGRect,
                      otherObjectFrame: CGRect,
                      proposedOtherObjectFrame: CGRect) -> [ContactContext.ContactSideAndOffset] {
        return contactSides(for: colliderMovement.collider,
                            currentPosition: colliderMovement.currentPosition,
                            proposedPosition: colliderMovement.proposedPosition,
                            currentHitPoints: colliderMovement.currentHitPoints,
                            proposedHitPoints: colliderMovement.proposedHitPoints,
                            intersection: intersection,
                            otherObjectFrame: otherObjectFrame,
                            proposedOtherObjectFrame: proposedOtherObjectFrame)
    }
}
