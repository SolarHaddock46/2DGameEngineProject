//
//  ResponderView.swift
//  YAEngine
//

#if os(OSX)
import AppKit
#else
import UIKit
#endif

public class ResponderView: View {
    #if os(OSX)
    // This is to prevent beep sounds heard when keyboard is
    // only handled via GCKeyboard.
    public override func keyDown(with event: NSEvent) {}
    public override func keyUp(with event: NSEvent) {}
    open override func flagsChanged(with event: NSEvent) {}
    #elseif os(tvOS) && targetEnvironment(simulator)
    func addGestureRecognizers() {
        
        let playPauseTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedPlayPause(recognizer:)))
        playPauseTapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)]
        addGestureRecognizer(playPauseTapRecognizer)
        
        let menuTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedMenu(recognizer:)))
        menuTapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        addGestureRecognizer(menuTapRecognizer)
        
        let selectTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedSelect(recognizer:)))
        selectTapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        addGestureRecognizer(selectTapRecognizer)
        
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedRight(recognizer:)))
        swipeRightRecognizer.direction = .right
        addGestureRecognizer(swipeRightRecognizer)
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedLeft(recognizer:)))
        swipeLeftRecognizer.direction = .left
        addGestureRecognizer(swipeLeftRecognizer)
        
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedUp(recognizer:)))
        swipeUpRecognizer.direction = .up
        addGestureRecognizer(swipeUpRecognizer)
        
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipedDown(recognizer:)))
        swipeDownRecognizer.direction = .down
        addGestureRecognizer(swipeDownRecognizer)
    }
    
    @objc func tappedPlayPause(recognizer: UITapGestureRecognizer) {
        Input.shared.addKey(KeyCode.controller1ButtonA, removeAtNextUpdate: true)
    }
    
    @objc func tappedMenu(recognizer: UITapGestureRecognizer) {
        Input.shared.addKey(KeyCode.controller1Menu, removeAtNextUpdate: true)
    }
    
    @objc func tappedSelect(recognizer: UITapGestureRecognizer) {
        Input.shared.addKey(KeyCode.controller1ButtonA, removeAtNextUpdate: true)
    }
    
    @objc func swipedRight(recognizer: UISwipeGestureRecognizer) {
        Input.shared.addKey(KeyCode.controller1DpadRight, removeAtNextUpdate: true)
    }
    
    @objc func swipedLeft(recognizer: UISwipeGestureRecognizer) {
        Input.shared.addKey(KeyCode.controller1DpadLeft, removeAtNextUpdate: true)
    }
    
    @objc func swipedUp(recognizer: UISwipeGestureRecognizer) {
        Input.shared.addKey(KeyCode.controller1DpadUp, removeAtNextUpdate: true)
    }
    
    @objc func swipedDown(recognizer: UISwipeGestureRecognizer) {
        Input.shared.addKey(KeyCode.controller1DpadDown, removeAtNextUpdate: true)
    }
    #endif
}
