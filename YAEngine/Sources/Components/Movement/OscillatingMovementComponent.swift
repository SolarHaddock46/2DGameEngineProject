//
//  OscillatingMovementComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that is used to move its entity with a simple harmonic motion.
/// Manipulates the transform position directly rather than changing the kinematics body.
public final class OscillatingMovementComponent: GKComponent, YAComponent {
    
    public static let componentPriority: Int = 870
    
    /// Period for the simple harmonic motion.
    public let period: TimeInterval
    
    /// Axes and speed of the movement.
    /// For example, if dx value is 0, there will be no movement on the horizontal axis.
    public let axesAndSpeed: CGVector
    
    /// Create an oscillating movement component.
    ///
    /// - Parameters:
    ///     - period: Period for the simple harmonic motion.
    ///     - axes: Axes and speed of the harmonic motion.
    public init(period: TimeInterval, axesAndSpeed: CGVector) {
        self.period = period
        self.axesAndSpeed = axesAndSpeed
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func didUpdate(deltaTime seconds: TimeInterval) {
        updateProposedPosition()
    }
    
    // MARK: - Private
    
    private func updateProposedPosition() {
        guard
            let transform = transform,
            let currentTime = currentTime
            else {
                return
        }
        
        let cycles = abs(CGFloat(period)) * CGFloat(currentTime) // ft
        let sinWave = sin(2.0 * CGFloat.pi * cycles) // 2pift
        
        transform.proposedPosition = transform.initialPosition + axesAndSpeed * sinWave
    }
}
