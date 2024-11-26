//
//  SpriteNodeComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that renders a sprite node as a child of its entity's transform node.
public final class SpriteNodeComponent: GKSKNodeComponent, GlideComponent, ZPositionContainerIndicatorComponent {
    
    public static let componentPriority: Int = 990
    
    public var zPositionContainer: ZPositionContainer?
    
    /// Same as this component's `node` value, referenced as a SKSpriteNode for convenience.
    public let spriteNode: SKSpriteNode
    
    /// Position of the sprite node, defined as `offset` from the transform's node.
    public var offset: CGPoint = .zero
    
    /// Additional offset to use on top of this component's `offset` value.
    public var additionalOffset: CGPoint = .zero
    
    // MARK: - Initialize
    
    /// Create a sprite node component with a sprite node of given size.
    ///
    /// - Parameters:
    ///     - nodeSize: Size of the sprite node.
    public init(nodeSize: CGSize) {
        self.spriteNode = SKSpriteNode(color: .clear, size: nodeSize)
        super.init(node: spriteNode)
    }
    
    /// Create a sprite node component with a sprite node of given size.
    ///
    /// - Parameters:
    ///     - tiledNodeSize: Size of the sprite node in tile units. Note that the node
    /// will get this size after scene's update loop starts.
    public convenience init(tiledNodeSize: TiledSize) {
        self.init(nodeSize: .zero)
        self.initialTiledNodeSize = tiledNodeSize
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func start() {
        guard let transform = transform else {
            return
        }
        guard let scene = scene else {
            return
        }
        
        if let initialTiledNodeSize = initialTiledNodeSize {
            spriteNode.size = initialTiledNodeSize.size(with: scene.tileSize)
        }
        
        transform.node.addChild(spriteNode)
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        let rounded = (offset + additionalOffset).glideRound
        spriteNode.position = rounded
    }
    
    // MARK: - Private
    
    private var initialTiledNodeSize: TiledSize?
}
