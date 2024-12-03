//
//  LerpingMovementComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that is used to move its entity via interpolating the distance between
/// entity's current position and a given target position.
/// This movement component manipulates the transform position directly.
public final class LerpingMovementComponent: GKComponent, YAComponent {
    
    public static let componentPriority: Int = 860
    
    /// Speed of the movement in points/s.
    public let speed: CGFloat
    /// Target point to reach, can be set dynamically.
    public var targetPoint: CGPoint?
    
    public init(speed: CGFloat) {
        self.speed = speed
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func didUpdate(deltaTime seconds: TimeInterval) {
        guard
            let transform = transform,
            let targetPoint = targetPoint
        else {
            return
        }
        
        let lerpingTime = CGFloat(seconds) * speed
        
        /// Because of rounding floating pixels in the engine, we might never be able to
        /// change the current position, this is a safety against this behavior.
        var numberOfTries = 10
        var newLerped = transform.currentPosition.lerp(destination: targetPoint,
                                                       time: lerpingTime)
        var lerped = CGPoint(x: newLerped.x.glideRound, y: newLerped.y.glideRound)
        while lerped == transform.currentPosition, numberOfTries >= 0 {
            newLerped = newLerped.lerp(destination: targetPoint,
                                       time: lerpingTime)
            lerped = CGPoint(x: newLerped.x.glideRound, y: newLerped.y.glideRound)
            numberOfTries -= 1
        }
        transform.proposedPosition = newLerped
    }
}
