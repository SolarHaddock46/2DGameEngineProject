//
//  LightMask.swift
//  YAEngine
//

import Foundation

/// Protocol to adopt to for light mask types.
/// This is used for the `lightingBitMask` of `LightNodeComponent`'s node.
public protocol LightMask {
    var rawValue: UInt32 { get }
}
