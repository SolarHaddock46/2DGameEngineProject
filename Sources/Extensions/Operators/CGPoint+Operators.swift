//
//  CGPoint+Operators.swift
//  YAEngine
//

import CoreGraphics

public func dot (left: CGPoint, right: CGPoint) -> CGFloat {
    return left.x * right.x + left.y * right.y
}

/// Adds two CGPoint values and returns the result as a new CGPoint.
public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

/// Increments a CGPoint with the value of another.
public func += (left: inout CGPoint, right: CGPoint) {
    // swiftlint:disable:next shorthand_operator
    left = left + right
}

/// Subtracts two CGPoint values and returns the result as a new CGPoint.
public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

/// Decrements a CGPoint with the value of another.
public func -= (left: inout CGPoint, right: CGPoint) {
    // swiftlint:disable:next shorthand_operator
    left = left - right
}

/// Multiplies two CGPoint values and returns the result as a new CGPoint.
public func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

/// Multiplies a CGPoint with another.
public func *= (left: inout CGPoint, right: CGPoint) {
    // swiftlint:disable:next shorthand_operator
    left = left * right
}

/// Divides two CGPoint values and returns the result as a new CGPoint.
public func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

/// Divides a CGPoint by another.
public func /= (left: inout CGPoint, right: CGPoint) {
    // swiftlint:disable:next shorthand_operator
    left = left / right
}

// MARK: - CGPoint & CGFloat

/// Multiplies the x and y fields of a CGPoint with the same scalar value and
/// returns the result as a new CGPoint.
public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

/// Multiplies the x and y fields of a CGPoint with the same scalar value.
public func *= (point: inout CGPoint, scalar: CGFloat) {
    // swiftlint:disable:next shorthand_operator
    point = point * scalar
}

/// Divides the x and y fields of a CGPoint by the same scalar value and returns
/// the result as a new CGPoint.
public func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

/// Divides the x and y fields of a CGPoint by the same scalar value.
public func /= (point: inout CGPoint, scalar: CGFloat) {
    // swiftlint:disable:next shorthand_operator
    point = point / scalar
}

// MARK: - CGPoint & CGVector

/// Adds a CGVector to this CGPoint and returns the result as a new CGPoint.
public func + (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x + right.dx, y: left.y + right.dy)
}

/// Increments a CGPoint with the value of a CGVector.
public func += (left: inout CGPoint, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left + right
}

/// Subtracts a CGVector from a CGPoint and returns the result as a new CGPoint.
public func - (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x - right.dx, y: left.y - right.dy)
}

/// Decrements a CGPoint with the value of a CGVector.
public func -= (left: inout CGPoint, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left - right
}

/// Multiplies a CGPoint with a CGVector and returns the result as a new CGPoint.
public func * (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x * right.dx, y: left.y * right.dy)
}

/// Multiplies a CGPoint with a CGVector.
public func *= (left: inout CGPoint, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left * right
}

/// Divides a CGPoint by a CGVector and returns the result as a new CGPoint.
public func / (left: CGPoint, right: CGVector) -> CGPoint {
    return CGPoint(x: left.x / right.dx, y: left.y / right.dy)
}

/// Divides a CGPoint by a CGVector.
public func /= (left: inout CGPoint, right: CGVector) {
    // swiftlint:disable:next shorthand_operator
    left = left / right
}
