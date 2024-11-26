//
//  CategoryMask.swift
//  YAEngine
//

import Foundation

/// Mask that defines which category an entity belongs to.
public protocol CategoryMask {
    var rawValue: UInt32 { get }
}

public func == (lhs: CategoryMask, rhs: CategoryMask) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
