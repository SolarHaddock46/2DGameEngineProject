//
//  LayoutGuide.swift
//  YAEngine
//

#if os(OSX)
import AppKit.NSLayoutGuide
public typealias LayoutGuideType = NSLayoutGuide
#else
import UIKit.UILayoutGuide
public typealias LayoutGuideType = UILayoutGuide
#endif

open class LayoutGuide: LayoutGuideType {}
