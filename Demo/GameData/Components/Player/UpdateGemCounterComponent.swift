//
//  UpdateGemCounterComponent.swift
//  glide Demo
//


import GameplayKit
import YAEngine

class UpdateGemCounterComponent: GKComponent, YAComponent {
    
    let gemCounterEntity: GemCounterEntity
    
    init(gemCounterEntity: GemCounterEntity) {
        self.gemCounterEntity = gemCounterEntity
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleNewContact(_ contact: Contact) {
        if let otherCollider = contact.otherObject.colliderComponent {
            if otherCollider.categoryMask == DemoCategoryMask.collectible {
                gemCounterEntity.numberOfGems += 1
            }
        }
    }
}
