//
//  Direction.swift
//  YAEngine
//

import Foundation

/// Represents direction of movement on an axis of 2d space.
public enum Direction: Equatable {
    /// Represents direction when there is no movement.
    case stationary
    case positive
    case negative
    
    public static prefix func ! (lhs: Direction) -> Direction {
        switch lhs {
        case .stationary:
            return .stationary
        case .positive:
            return .negative
        case .negative:
            return .positive
        }
    }
}
