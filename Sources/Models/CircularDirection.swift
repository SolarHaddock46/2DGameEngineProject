//
//  CircularDirection.swift
//  YAEngine
//

import Foundation

/// Represents direction of movement on a circular space.
public enum CircularDirection {
    case stationary
    case clockwise
    case counterClockwise
    
    public static prefix func ! (lhs: CircularDirection) -> CircularDirection {
        switch lhs {
        case .stationary:
            return .stationary
        case .clockwise:
            return .counterClockwise
        case .counterClockwise:
            return .clockwise
        }
    }
}
