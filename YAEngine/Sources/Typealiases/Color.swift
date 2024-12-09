//
//  DisplayLinkObserver.swift
//  YAEngine
//

#if os(OSX)
import AppKit.NSColor
public typealias Color = NSColor

extension NSColor {
    public convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.init(srgbRed: red, green: green, blue: blue, alpha: alpha)
    }
}
#else
import UIKit.UIColor
public typealias Color = UIColor
#endif

extension Color {
    
    #if !os(OSX)
    public var redComponent: CGFloat {
        var value: CGFloat = 0.0
        getRed(&value, green: nil, blue: nil, alpha: nil)
        return value
    }
    
    public var greenComponent: CGFloat {
        var value: CGFloat = 0.0
        getRed(nil, green: &value, blue: nil, alpha: nil)
        return value
    }
    
    public var blueComponent: CGFloat {
        var value: CGFloat = 0.0
        getRed(nil, green: nil, blue: &value, alpha: nil)
        return value
    }
    
    public var alphaComponent: CGFloat {
        var value: CGFloat = 0.0
        getRed(nil, green: nil, blue: nil, alpha: &value)
        return value
    }
    #endif
}
