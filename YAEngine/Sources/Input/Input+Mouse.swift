//
//  Input+Mouse.swift
//  YAEngine
//

import Foundation
import GameController

extension Input {
    func setupMouse() {
        gameControllerObserver.mouseConnectionChangedHandler = { [weak self] connectedMouse in
            guard let self = self else { return }
            
            if let mouse = connectedMouse {
                self.connectMouse(mouse)
            } else {
                self.disconnectMouse()
            }
        }
        
        if let mouse = gameControllerObserver.connectedMouse {
            connectMouse(mouse)
        }
    }
    
    private func connectMouse(_ mouse: GCMouse) {
        connectedMouse = mouse
        
        mouse.mouseInput?.leftButton.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if pressed {
                self.addKey(.mouseLeft, value: value)
            } else {
                self.removeKey(.mouseLeft)
            }
        }
        
        mouse.mouseInput?.rightButton?.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if pressed {
                self.addKey(.mouseRight, value: value)
            } else {
                self.removeKey(.mouseRight)
            }
        }
        
        mouse.mouseInput?.middleButton?.pressedChangedHandler = { [weak self] _, value, pressed in
            guard let self = self else { return }
            
            if pressed {
                self.addKey(.mouseMiddle, value: value)
            } else {
                self.removeKey(.mouseMiddle)
            }
        }
        
        mouse.mouseInput?.mouseMovedHandler = { [weak self] _, deltaX, deltaY in
            guard let self = self else { return }
            
            self.mouseDelta = CGPoint(x: CGFloat(deltaX), y: CGFloat(deltaY))
            self.mousePosition += self.mouseDelta
        }
    }
    
    private func disconnectMouse() {
        connectedMouse = nil
    }
}
