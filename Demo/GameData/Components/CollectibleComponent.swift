//
//  CollectibleComponent.swift
//  YAEngine Demo
//


import GameplayKit
import YAEngine

class CollectibleComponent: GKComponent, YAComponent, RemovalControllingComponent {
    
    var isCollected: Bool = false
    let magicAnimationEntity = AnimationEntityFactory.magicAnimationEntity(at: .zero)
    
    func handleNewContact(_ contact: Contact) {
        guard isCollected == false else {
            return
        }
        isCollected = true
        if let transform = transform {
            magicAnimationEntity.transform.currentPosition = transform.node.position
            scene?.addEntity(magicAnimationEntity)
        }
    }
    
    var canEntityBeRemoved: Bool {
        return isCollected
    }
}
