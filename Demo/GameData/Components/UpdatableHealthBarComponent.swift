//
//  UpdatableHealthBarComponent.swift
//  YAEngine Demo
//


import GameplayKit
import YAEngine

class UpdatableHealthBarComponent: GKComponent, YAComponent {
    let updateCallback: (_ numberOfHearts: Int) -> Void
    
    var numberOfHearts: Int {
        didSet {
            updateCallback(numberOfHearts)
        }
    }
    
    init(numberOfHearts: Int, updateCallback: @escaping (_ numberOfHearts: Int) -> Void) {
        self.numberOfHearts = numberOfHearts
        self.updateCallback = updateCallback
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
