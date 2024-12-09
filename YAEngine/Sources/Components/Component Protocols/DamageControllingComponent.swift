//
//  DamageControllingComponent.swift
//  YAEngine
//

import Foundation

/// When adopted, a component can effect its entity's damage taking capabilities.
protocol DamageControllingComponent {
    
    /// `true` if this component's entity is allowed to take damage.
    var canEntityTakeDamage: Bool { get }
}
