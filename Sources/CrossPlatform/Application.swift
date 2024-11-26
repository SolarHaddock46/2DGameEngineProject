//
//  Application.swift
//  YAEngine
//

#if os(OSX)
import AppKit.NSApplication
public typealias ApplicationType = NSApplication
#else
import UIKit.UIApplication
public typealias ApplicationType = UIApplication
#endif

open class Application: ApplicationType {}
