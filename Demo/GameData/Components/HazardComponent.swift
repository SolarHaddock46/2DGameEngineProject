//
//  HazardComponent.swift
//  YAEngine Demo
//


import GameplayKit
import YAEngine

class HazardComponent: GKComponent, YAComponent {
    func handleNewContact(_ contact: Contact) {
        contact.otherObject.colliderComponent?.entity?.component(ofType: HealthComponent.self)?.applyDamage(1)
    }
}
