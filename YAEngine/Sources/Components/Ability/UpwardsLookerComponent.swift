//
//  UpwardsLookerComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that gives an entity the ability to adjust the camera to focus it
/// above the entity's node, if camera is already focused on this entity's transform.
public final class UpwardsLookerComponent: GKComponent, GlideComponent {
    public static let componentPriority: Int = 680
    
    /// `true` if the entity was looking upwards in the last frame.
    public private(set) var didLookUpwards: Bool = false
    
    /// `true` if the entity is looking upwards in the current frame.
    public var looksUpwards: Bool = false
    
    public var focusOffset: CGPoint = .zero
    
    public override func update(deltaTime seconds: TimeInterval) {
        if looksUpwards {
            focusOffset = CGPoint(x: 0, y: 80)
        } else {
            focusOffset = .zero
        }
    }
}

extension UpwardsLookerComponent: CameraFocusingComponent { }

extension UpwardsLookerComponent: StateResettingComponent {
    public func resetStates() {
        didLookUpwards = looksUpwards
        looksUpwards = false
    }
}
