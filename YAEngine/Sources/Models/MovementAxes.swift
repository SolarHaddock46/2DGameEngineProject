//
//  MovementAxes.swift
//  YAEngine
//

import Foundation

/// Represents different options for axes of movement.
public struct MovementAxes: OptionSet, Sequence {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let horizontal = MovementAxes(rawValue: 1 << 0)
    public static let vertical = MovementAxes(rawValue: 1 << 1)
    public static let circular = MovementAxes(rawValue: 1 << 2)
}
