//
//  CGVector+Operators.swift
//  YAEngine
//

import CoreGraphics

/// Adds two CGVector values and returns the result as a new CGVector.
public func + (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
}

/// Increments a CGVector with the value of another.
public func += (left: inout CGVector, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left + right
}

/// Subtracts two CGVector values and returns the result as a new CGVector.
public func - (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
}

/// Decrements a CGVector with the value of another.
public func -= (left: inout CGVector, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left - right
}

/// Multiplies two CGVector values and returns the result as a new CGVector.
public func * (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx * right.dx, dy: left.dy * right.dy)
}

/// Multiplies a CGVector with another.
public func *= (left: inout CGVector, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left * right
}

/// Divides two CGVector values and returns the result as a new CGVector.
public func / (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx / right.dx, dy: left.dy / right.dy)
}

/// Divides a CGVector by another.
public func /= (left: inout CGVector, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left / right
}

// MARK: - CGVector & CGFloat

/// Multiplies the x and y fields of a CGVector with the same scalar value and
/// returns the result as a new CGVector.
public func * (vector: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}

/// Multiplies the x and y fields of a CGVector with the same scalar value.
public func *= (vector: inout CGVector, scalar: CGFloat) {
    // swiftlint:disable:next shorthand_operator
    vector = vector * scalar
}

/// Divides the dx and dy fields of a CGVector by the same scalar value and
/// returns the result as a new CGVector.
public func / (vector: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
}

/// Divides the dx and dy fields of a CGVector by the same scalar value.
public func /= (vector: inout CGVector, scalar: CGFloat) {
    // swiftlint:disable:next shorthand_operator
    vector = vector / scalar
}
