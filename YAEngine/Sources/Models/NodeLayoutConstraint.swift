//
//  NodeLayoutConstraint.swift
//  YAEngine
//

import CoreGraphics

/// Types of constraining a node's dimensions.
public enum NodeLayoutConstraint {
    /// Constraint is a constant float.
    case constant(CGFloat)
    /// Constraint is calculated as a multiplier of the respective screen dimension.
    case proportionalToSceneSize(CGFloat)
}
