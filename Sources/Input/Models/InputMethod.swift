//
//  InputMethod.swift
//  YAEngine
//

import Foundation

public extension Notification.Name {
    /// Notification posted when recognized input method changes.
    /// React to this to update your input related UI/game elements.
    static let InputMethodDidChange = Notification.Name("InputMethodDidChange")
}

/// Represents main type of input method currently recognized by an input controller.
public enum InputMethod {
    /// No game controllers are currently connected. Represents touch inputs on iOS,
    /// mouse and keyboard events on macOS. This case doesn't exist on tvOS where
    /// at least one game controller is always connected (Siri Remote).
    case native
    /// At least one game controller is connected.
    case gameController
    
    #if os(iOS)
    /// `true` if the touch inputs are enabled.
    public var isTouchesEnabled: Bool {
        return Input.shared.connectedKeyboard == nil
    }
    #endif
    
    /// `true` if the focus highlights should be indicated on UI elements.
    public var shouldDisplayFocusOnUI: Bool {
        switch self {
        case .gameController:
            return true
        case .native:
            #if os(iOS)
            return !isTouchesEnabled
            #else
            return true
            #endif
        }
    }
}
