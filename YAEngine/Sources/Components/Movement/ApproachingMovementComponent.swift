//
//  ApproachingMovementComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that is used to move its entity by `CGPoint.approach(destination:maximumDelta:)`.
/// This movement component manipulates the transform position directly.
public final class ApproachingMovementComponent: GKComponent, YAComponent {
    
    public static let componentPriority: Int = 850
    
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
        
        let timing = CGFloat(seconds) * speed
        
        /// Because of rounding floating pixels in the engine, we might never be able to
        /// change the current position, this is a safety against this behavior.
        var numberOfTries = 10
        var newTarget = transform.currentPosition.approach(destination: targetPoint,
                                                           maximumDelta: timing)
        var target = CGPoint(x: newTarget.x.glideRound, y: newTarget.y.glideRound)
        while target == transform.currentPosition, numberOfTries >= 0 {
            newTarget = newTarget.approach(destination: targetPoint,
                                           maximumDelta: timing)
            target = CGPoint(x: newTarget.x.glideRound, y: newTarget.y.glideRound)
            numberOfTries -= 1
        }
        
        transform.proposedPosition = newTarget
    }
}
