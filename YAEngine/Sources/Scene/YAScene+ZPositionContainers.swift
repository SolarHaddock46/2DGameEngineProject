//
//  GlideScene+ZPositionContainers.swift
//  YAEngine
//

import SpriteKit

extension YAScene {
    
    func constructZPositionContainerNodes() {
        var zPosition: CGFloat = 1000
        for container in zPositionContainers {
            if container is YAZPositionContainer {
                fatalError("Order container name is reserved: \(container)")
            }
            let node = SKNode()
            node.name = zPositionContainerNodeName(container)
            node.zPosition = zPosition
            addChild(node)
            zPosition += 1000
        }
    }
    
    func zPositionContainerNode(with zPositionContainer: ZPositionContainer) -> SKNode? {
        let container = childNode(withName: zPositionContainerNodeName(zPositionContainer))
        if zPositionContainer.rawValue == YAZPositionContainer.camera.rawValue {
            if let camera = container?.children.first(where: { $0 is SKCameraNode }) {
                return camera
            }
        }
        return container
    }
    
    func zPositionContainerNodeName(_ zPositionContainer: ZPositionContainer) -> String {
        return "Glide.ZPositionContainer.\(zPositionContainer.rawValue)"
    }
}
