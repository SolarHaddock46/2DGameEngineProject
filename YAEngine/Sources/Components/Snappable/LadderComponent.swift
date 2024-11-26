//
//  LadderComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that provides snapping behaviors of a ladder.
public final class LadderComponent: GKComponent, GlideComponent {
    
    public func handleNewContact(_ contact: Contact) {
        handleSnapping(with: contact)
    }
    
    public func handleExistingContact(_ contact: Contact) {
        handleSnapping(with: contact)
    }
    
    // MARK: - Private
    
    private func handleSnapping(with contact: Contact) {
        let otherEntity = contact.otherObject.colliderComponent?.entity
        guard
            let ladderClimber = otherEntity?.component(ofType: LadderClimberComponent.self),
            let snapper = otherEntity?.component(ofType: SnapperComponent.self)
            else {
                return
        }
        
        ladderClimber.isContactingLadder = true
        
        if ladderClimber.isHolding {
            snapper.isSnapping = true
            snapper.snappedPositionCallback = { [weak self] transform in
                guard let self = self else { return nil }
                guard let selfTransform = self.transform else { return nil }
                return CGPoint(x: selfTransform.proposedPosition.x, y: transform.proposedPosition.y)
            }
        }
    }
}
