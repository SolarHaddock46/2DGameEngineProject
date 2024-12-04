//
//  GlideCategoryMask.swift
//  YAEngine
//

import Foundation

/// Default categories to which objects in a `GlideScene` belongs.
public enum YACategoryMask: UInt32, CategoryMask {
    case none = 0
    case player = 1
    case colliderTile = 2
    /// All entities with a `SnappableComponent`
    case snappable = 3
}
