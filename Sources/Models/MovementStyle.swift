//
//  MovementStyle.swift
//  YAEngine
//

import Foundation

/// Type of movement used by various movement related components.
/// Velocity and acceleration/deceleration values can be set through
/// the configuration of related component. The reason for not using
/// associated values for those is to be aligned with configuration handling.
public enum MovementStyle {
    /// Uniform velocity
    case fixedVelocity
    /// Movement with a fixed acceleration or deceleration
    case accelerated
}
