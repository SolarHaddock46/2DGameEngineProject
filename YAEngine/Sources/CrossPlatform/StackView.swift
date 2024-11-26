//
//  StackView.swift
//  YAEngine
//

#if os(OSX)
import AppKit.NSStackView
public typealias StackViewType = NSStackView
#else
import UIKit.UIStackView
public typealias StackViewType = UIStackView
#endif

public enum StackViewOrientation: Int {
    case horizontal
    case vertical
    
    #if os(OSX)
    var underlying: NSUserInterfaceLayoutOrientation {
        switch self {
        case .vertical:
            return NSUserInterfaceLayoutOrientation.vertical
        case .horizontal:
            return NSUserInterfaceLayoutOrientation.horizontal
        }
    }
    
    #else
    var underlying: NSLayoutConstraint.Axis {
        switch self {
        case .vertical:
            return NSLayoutConstraint.Axis.vertical
        case .horizontal:
            return NSLayoutConstraint.Axis.horizontal
        }
    }
    #endif
}

open class StackView: StackViewType {
    open var orientationAndAxis: StackViewOrientation {
        set {
            #if os(OSX)
            orientation = newValue.underlying
            #else
            axis = newValue.underlying
            #endif
        }
        get {
            #if os(OSX)
            return StackViewOrientation(rawValue: orientation.rawValue) ?? .horizontal
            #else
            return StackViewOrientation(rawValue: axis.rawValue) ?? .horizontal
            #endif
        }
    }
}
