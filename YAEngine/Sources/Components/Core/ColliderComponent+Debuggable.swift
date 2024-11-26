//
//  ColliderComponent+Debuggable.swift
//  YAEngine
//

import SpriteKit

extension ColliderComponent: DebuggableComponent {
    func addOrUpdateHitPointDebugNode(with name: String, index: Int, hitPoint: CGPoint) {
        let nodeName = debugElementName(with: "\(name)_\(index)")
        
        var result: SKSpriteNode
        
        defer {
            result.position = hitPoint + CGPoint(x: 0.5, y: 0.5)
        }
        
        if let existingNode = transform?.node.childNode(withName: nodeName) as? SKSpriteNode {
            result = existingNode
            return
        }
        
        let debugNodeSize = CGSize(width: 1, height: 1)
        let debugNode = SKSpriteNode(texture: nil, size: debugNodeSize)
        debugNode.name = nodeName
        debugNode.color = Color.cyan
        transform?.node.addChild(debugNode)
        result = debugNode
    }
    
    func removeHitPointDebugNode(with name: String) {
        let nodeName0 = debugElementName(with: "\(name)_0")
        transform?.node.childNode(withName: nodeName0)?.removeFromParent()
        let nodeName1 = debugElementName(with: "\(name)_1")
        transform?.node.childNode(withName: nodeName1)?.removeFromParent()
    }
    
    public func updateDebugElements() {
        if colliderFrameDebugNode.parent == nil {
            transform?.node.addChild(colliderFrameDebugNode)
        }
        
        colliderFrameDebugNode.position = offset
        
        drawDebugSpritesFor(leftHitPoints(at: .zero), debugSpriteName: "leftHitPoints")
        drawDebugSpritesFor(rightHitPoints(at: .zero), debugSpriteName: "rightHitPoints")
        drawDebugSpritesFor(bottomHitPoints(at: .zero), debugSpriteName: "bottomHitPoints")
        drawDebugSpritesFor(topHitPoints(at: .zero), debugSpriteName: "topHitPoints")
    }
    
    func drawDebugSpritesFor(_ hitPoints: (CGRect, CGRect), debugSpriteName: String) {
        addOrUpdateHitPointDebugNode(with: debugSpriteName, index: 0, hitPoint: hitPoints.0.origin)
        addOrUpdateHitPointDebugNode(with: debugSpriteName, index: 1, hitPoint: hitPoints.1.origin)
    }
    
    public func cleanDebugElements() {
        colliderFrameDebugNode.removeFromParent()
        removeHitPointDebugNode(with: "leftHitPoints")
        removeHitPointDebugNode(with: "rightHitPoints")
        removeHitPointDebugNode(with: "bottomHitPoints")
        removeHitPointDebugNode(with: "topHitPoints")
    }
}
