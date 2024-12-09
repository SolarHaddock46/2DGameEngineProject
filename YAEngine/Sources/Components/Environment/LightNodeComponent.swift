//
//  LightNodeComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that renders a light node as a child of its entity's transform node.
public final class LightNodeComponent: GKSKNodeComponent, YAComponent, ZPositionContainerIndicatorComponent {
    
    public var zPositionContainer: ZPositionContainer?
    
    /// Same as this component's `node` value, referenced as a SKLightNode for
    /// convenience.
    public let lightNode: SKLightNode
    
    /// Position of the light node, defined as `offset` from the transform's node.
    public var offset: CGPoint = .zero
    
    /// Additional offset to use on top of this component's `offset` value.
    public var additionalOffset: CGPoint = .zero
    
    // MARK: - Initialize
    
    /// Create a light node component.
    ///
    /// - Parameters:
    ///     - mask: `categoryBitMask` for this light to be used to assign as
    /// `lightingBitMask` value of other nodes.
    public init(mask: LightMask) {
        self.lightNode = SKLightNode()
        super.init(node: lightNode)
        lightNode.categoryBitMask = mask.rawValue
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start() {
        if let transform = transform {
            transform.node.addChild(node)
        }
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        let rounded = (offset + additionalOffset).yaRound
        lightNode.position = rounded
    }
}
