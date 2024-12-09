//
//  UpdateHealthBarComponent.swift
//  YAEngine Demo
//


import GameplayKit
import YAEngine

class UpdateHealthBarComponent: GKComponent, YAComponent {
    
    let updatableHealthBarComponent: UpdatableHealthBarComponent
    
    init(updatableHealthBarComponent: UpdatableHealthBarComponent) {
        self.updatableHealthBarComponent = updatableHealthBarComponent
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        updatableHealthBarComponent.numberOfHearts = Int(entity?.component(ofType: HealthComponent.self)?.remainingHealth ?? 0)
    }
    
    func didSkipUpdate() {
        updatableHealthBarComponent.numberOfHearts = Int(entity?.component(ofType: HealthComponent.self)?.remainingHealth ?? 0)
    }
}
