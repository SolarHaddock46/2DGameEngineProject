//
//  Button.swift
//  YAEngine
//

#if os(OSX)
import AppKit.NSButton
public typealias ButtonType = NSButton
#else
import UIKit.UIButton
public typealias ButtonType = UIButton
#endif

open class Button: ButtonType {
    #if !os(OSX)
    open var title: String? {
        set {
            setTitle(newValue, for: .normal)
        }
        get {
            return title(for: .normal)
        }
    }
    
    open var wantsLayer: Bool {
        set {
            // Does nothing
        }
        get {
            return true
        }
    }
    #endif
}
