//
//  ProjectileTemplateEntity.swift
//  YAEngine
//

import Foundation
import CoreGraphics

/// Template entity to be used a base class for projectile entities
/// which are initialized and added to scene by `ProjectileShooterComponent`.
/// An example is a bullet of a pistol.
open class ProjectileTemplateEntity: GlideEntity {
    
    /// Initial shooting angle value in degrees.
    public let shootingAngle: CGFloat
    
    /// Initial velocity in m/s.
    public let initialVelocity: CGVector
    
    // MARK: - Initialize
    
    /// Create a projectile template entity.
    ///
    ///
    /// - Parameters:
    ///     - initialNodePosition: Initial position for the transform of the entity.
    ///     - shootingAngle: Angle for the direction of shooting in degrees.
    public required init(initialNodePosition: CGPoint,
                         initialVelocity: CGVector,
                         shootingAngle: CGFloat) {
        self.shootingAngle = shootingAngle
        self.initialVelocity = initialVelocity
        super.init(initialNodePosition: initialNodePosition, positionOffset: .zero)
    }
}
