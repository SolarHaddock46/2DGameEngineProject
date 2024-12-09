//
//  TriggerZoneComponent.swift
//  YAEngine Demo
//


import GameplayKit
import YAEngine

class TriggerZoneComponent: GKComponent, YAComponent {
    let callback: (_ entered: Bool) -> Void
    
    init(callback: @escaping (Bool) -> Void) {
        self.callback = callback
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleNewContact(_ contact: Contact) {
        callback(true)
    }
    
    func handleFinishedContact(_ contact: Contact) {
        callback(false)
    }
}
