//
//  HitPoints.swift
//  YAEngine
//

import CoreGraphics

/// Represents locations of hit points of a collider box.
struct HitPoints {
    let top: (left: CGRect, right: CGRect)
    let left: (bottom: CGRect, top: CGRect)
    let bottom: (left: CGRect, right: CGRect)
    let right: (bottom: CGRect, top: CGRect)
}
