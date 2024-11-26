//
//  Font.swift
//  YAEngine
//

#if os(OSX)
import AppKit.NSFont
public typealias Font = NSFont
#else
import UIKit.UIFont
public typealias Font = UIFont
#endif
