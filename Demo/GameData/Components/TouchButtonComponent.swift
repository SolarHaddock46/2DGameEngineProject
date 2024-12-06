//
//  ItemChestComponent.swift
//  glide Demo
//


import YAEngine
import SpriteKit
import GameplayKit

class TouchButtonComponent: GKSKNodeComponent, YAComponent, TouchReceiverComponent, ZPositionContainerIndicatorComponent {
    
    var zPositionContainer: ZPositionContainer?
    
    // MARK: - Touch Receiver
    
    var input: TouchInputProfilesOrCallback
    let triggersOnTouchUpInside: Bool
    
    var currentTouchCount: Int = 0
    
    let hitBoxNode: SKSpriteNode
    var normalTexture: SKTexture?
    var highlightedTexture: SKTexture?
    
    var isHighlighted: Bool = false
    
    init(size: CGSize,
         triggersOnTouchUpInside: Bool,
         input: TouchInputProfilesOrCallback) {
        self.hitBoxNode = SKSpriteNode(color: .clear, size: size)
        self.triggersOnTouchUpInside = triggersOnTouchUpInside
        self.input = input
        super.init(node: hitBoxNode)
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start() {
        transform?.node.addChild(hitBoxNode)
    }
    
    open override func update(deltaTime seconds: TimeInterval) {
        updateNodeTexture()
    }
    
    func updateNodeTexture() {
        if isHighlighted {
            hitBoxNode.texture = highlightedTexture
        } else {
            hitBoxNode.texture = normalTexture
        }
    }
    
    public func entityWillBeRemovedFromScene() {
        hitBoxNode.removeFromParent()
        currentTouchCount = 0
    }
}
