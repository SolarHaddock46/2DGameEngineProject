//
//  CGSize+Operators.swift
//  YAEngine
//

import CoreGraphics

/// Divides the size fields by a given scalar.
public func / (size: CGSize, scalar: CGFloat) -> CGSize {
    return CGSize(width: size.width / scalar, height: size.height / scalar)
}

/// Multiplies the size fields with a given scalar.
public func * (size: CGSize, scalar: CGFloat) -> CGSize {
    return CGSize(width: size.width * scalar, height: size.height * scalar)
}

// MARK: - CGSize & CGSize

/// Adds two size values and returns this as a new size.
public func + (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width + right.width, height: left.height + right.height)
}

/// Multiplies two size values with each other and returns this as a new size.
public func * (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width * right.width, height: left.height * right.height)
}

// MARK: - CGPoint & CGSize

/// Subtracts fields of a size from the fields of a point and returns the result as a point.
public func - (left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x - right.width, y: left.y - right.height)
}

/// Adds fields of a size to the fields of a point and returns the result as a point.
public func + (left: CGPoint, right: CGSize) -> CGPoint {
    return CGPoint(x: left.x + right.width, y: left.y + right.height)
}

/// Decrements the fields of a point with the values of the fields of a size.
public func -= (left: inout CGPoint, right: CGSize) {
    // swiftlint:disable:next shorthand_operator
    left = left - right
}

/// Increments the fields of a point with the values of the fields of a size.
public func += (left: inout CGPoint, right: CGSize) {
    // swiftlint:disable:next shorthand_operator
    left = left - right
}
