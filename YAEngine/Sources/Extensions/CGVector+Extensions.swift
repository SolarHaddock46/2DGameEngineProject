//
//  CGVector+Extensions.swift
//  YAEngine
//

import CoreGraphics
import SpriteKit

public extension CGVector {
    
    /// Creates a new CGVector given a CGPoint.
    init(point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }
    
    /// Given an angle in radians, creates a vector of length 1.0 and returns the
    /// result as a new CGVector. An angle of 0 is assumed to point to the right.
    init(angle: CGFloat) {
        self.init(dx: cos(angle), dy: sin(angle))
    }
    
    /// Adds (dx, dy) to the vector.
    mutating func offset(dx: CGFloat, dy: CGFloat) -> CGVector {
        self.dx += dx
        self.dy += dy
        return self
    }
    
    /// Returns the length (magnitude) of the vector described by the CGVector.
    func length() -> CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
    
    /// Returns the squared length of the vector described by the CGVector.
    func lengthSquared() -> CGFloat {
        return dx * dx + dy * dy
    }
    
    /// Normalizes the vector described by the CGVector to length 1.0 and returns
    /// the result as a new CGVector.
    func normalized() -> CGVector {
        let len = length()
        return len > 0 ? self / len : CGVector.zero
    }
    
    /// Normalizes the vector described by the CGVector to length 1.0.
    mutating func normalize() -> CGVector {
        self = normalized()
        return self
    }
    
    /// Calculates the distance between two CGVectors. Pythagoras!
    func distanceTo(_ vector: CGVector) -> CGFloat {
        return (self - vector).length()
    }
    
    /// Returns the angle in radians of the vector described by the CGVector.
    /// The range of the angle is -π to π; an angle of 0 points to the right.
    var angle: CGFloat {
        return atan2(dy, dx)
    }
}
