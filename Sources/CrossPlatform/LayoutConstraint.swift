//
//  LayoutConstraint.swift
//  YAEngine
//

#if os(OSX)
import AppKit
#else
import UIKit
#endif

open class LayoutConstraint: NSLayoutConstraint {
    #if os(OSX)
    #else
    public typealias Priority = UILayoutPriority
    public typealias Orientation = Axis
    #endif
}
