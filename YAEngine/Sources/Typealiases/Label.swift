//
//  Label.swift
//  YAEngine
//

#if os(OSX)
import AppKit.NSTextField
public typealias LabelType = NSTextField
#else
import UIKit.UILabel
public typealias LabelType = UILabel
#endif

open class Label: LabelType {
    #if os(OSX)
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public func setup() {
        alignment = .center
        isBezeled = false
        isEditable = false
        drawsBackground = false
    }
    
    public var text: String? {
        get {
            return stringValue
        }
        set {
            stringValue = newValue ?? ""
        }
    }
    
    public var attributedText: NSAttributedString {
        get {
            return attributedStringValue
        }
        set {
            attributedStringValue = newValue
        }
    }
    
    public var textAlignment: NSTextAlignment {
        get {
            return alignment
        }
        set {
            alignment = newValue
        }
    }
    
    #else
    public var maximumNumberOfLines: Int {
        get {
            return numberOfLines
        }
        set {
            numberOfLines = newValue
        }
    }
    #endif
}
