//
//  GlideScene+KeyboardAndMouseInput.swift
//  YAEngine
//

#if os(macOS)
import AppKit

extension GlideScene {
    // This is to prevent beep sounds heard when keyboard is
    // only handled via GCKeyboard.
    open override func keyDown(with event: NSEvent) {}
    
    open override func keyUp(with event: NSEvent) {}
    
    open override func flagsChanged(with event: NSEvent) {}
}
#endif
