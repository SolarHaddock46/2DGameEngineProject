//
//  LabelNodeComponent.swift
//  YAEngine
//

import GameplayKit
import SpriteKit

/// Component that renders a label node as a child of its entity's transform node.
public final class LabelNodeComponent: GKSKNodeComponent, YAComponent, ZPositionContainerIndicatorComponent {
    
    public static let componentPriority: Int = 970
    
    public var zPositionContainer: ZPositionContainer?
    
    /// Same as this component's `node` value, referenced as a SKLabelNode for
    /// convenience.
    public let labelNode = SKLabelNode()
    
    /// Position of the label node, defined as `offset` from the transform's node.
    public var offset: CGPoint = .zero
    
    /// Additional offset to use on top of this component's `offset` value.
    public var additionalOffset: CGPoint = .zero
    
    // MARK: - Initialize
    
    public override init() {
        super.init(node: labelNode)
        labelNode.numberOfLines = 0
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start() {
        transform?.node.addChild(labelNode)
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        let rounded = (offset + additionalOffset).yaRound
        labelNode.position = rounded
    }
}
