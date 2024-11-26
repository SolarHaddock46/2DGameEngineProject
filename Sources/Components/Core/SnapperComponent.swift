//
//  SnapperComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that is used to establish collisions with snappable objects
/// like platforms and ladders. Snapping is a special behavior which helps with
/// partially establishing collisions between moving objects.
public final class SnapperComponent: GKComponent, GlideComponent {
    
    public static let componentPriority: Int = 930
    
    public private(set) var wasSnapping: Bool = false
    /// `true` if the entity is snapping to a snapper in the current frame.
    public var isSnapping: Bool = false
    /// Position returned from this callback is used in every update cycle to
    /// the position of the entity's tranform. This callback is to be set by a
    /// snappable component which sets and returns a modified proposed position.
    public var snappedPositionCallback: ((TransformNodeComponent) -> CGPoint?)?
    
    public func didUpdate(deltaTime seconds: TimeInterval) {
        guard let transform = transform else {
            return
        }
        
        if isSnapping {
            if let snappedProposedPosition = snappedPositionCallback?(transform) {
                transform.proposedPosition = snappedProposedPosition
            }
        }
    }
}

extension SnapperComponent: StateResettingComponent {
    public func resetStates() {
        wasSnapping = isSnapping
        isSnapping = false
        
        snappedPositionCallback = nil
    }
}
