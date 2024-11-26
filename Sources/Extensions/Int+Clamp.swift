//
//  Int+Clamp.swift
//  YAEngine
//

import Foundation

public extension Int {
    
    /// Clamps current integer bound by the values of a range.
    func clamped(_ range: Range<Int>) -> Int {
        if self < range.lowerBound {
            return range.lowerBound
        }
        if self >= range.upperBound {
            return range.upperBound - 1
        }
        return self
    }
    
    /// Clamps current integer bound by the values of a closed range.
    func clamped(_ range: ClosedRange<Int>) -> Int {
        if self < range.lowerBound {
            return range.lowerBound
        }
        if self > range.upperBound {
            return range.upperBound
        }
        return self
    }
}
