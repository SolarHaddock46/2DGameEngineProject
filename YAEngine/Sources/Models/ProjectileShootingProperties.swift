//
//  ProjectileShootingProperties.swift
//  YAEngine
//

import CoreGraphics

/// Represents initial properties to be used while shooting a projectile.
/// See `ProjectileShooterComponent` for more details.
public struct ProjectileShootingProperties {
    public let position: CGPoint
    public let sourceAngle: CGFloat
    public let velocity: CGVector
    
    public init(position: CGPoint, sourceAngle: CGFloat, velocity: CGVector = .zero) {
        self.position = position
        self.sourceAngle = sourceAngle
        self.velocity = velocity
    }
}
