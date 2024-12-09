//
//  CGFloat+GlideRound.swift
//  YAEngine
//

import CoreGraphics

extension CGFloat {
    
    /// Common way of rounding floating numbers in the framework.
    public var yaRound: CGFloat {
        return Darwin.round(self)
    }
}
