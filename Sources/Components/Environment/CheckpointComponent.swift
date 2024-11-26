//
//  CheckpointComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that makes an entity behave as a checkpoint of its scene.
/// Entities which have `CheckpointRecognizerComponent` will be able to
/// add the checkpoint of this component to their list, when they contact
/// with the collider of this component's entity.
/// It is required that transform of the entity of this component has
/// `usesProposedPosition` set to `false`.
public final class CheckpointComponent: GKComponent, GlideComponent {
    
    /// Checkpoint value for the component.
    public let checkpoint: Checkpoint
    
    /// `true` if the height of the entity's collider should extend to the upper
    /// border of the scene.
    /// Set to `false` if you want to keep the original height of the collider.
    public let adjustsColliderSize: Bool
    
    // MARK: - Initialize
    
    /// Create a checkpoint component.
    ///
    /// - Parameters:
    ///     - checkpoint: Checkpoint value for the component.
    public init(checkpoint: Checkpoint, adjustsColliderSize: Bool = true) {
        self.checkpoint = checkpoint
        self.adjustsColliderSize = adjustsColliderSize
        
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func update(deltaTime seconds: TimeInterval) {
        updatePosition()
    }
    
    public func handleNewContact(_ contact: Contact) {
        if let checkpointRecognizer = contact.otherObject.colliderComponent?.entity?.component(ofType: CheckpointRecognizerComponent.self) {
            if checkpointRecognizer.passedCheckpoints.contains(checkpoint) == false {
                checkpointRecognizer.passedCheckpoints.append(checkpoint)
            }
        }
    }
    
    // MARK: - Debuggable
    
    public static var isDebugEnabled: Bool = false
    
    public var isDebugEnabled: Bool = false
    
    // MARK: - Private
    
    private func updatePosition() {
        guard let colliderSize = entity?.component(ofType: ColliderComponent.self)?.size else {
            return
        }
        guard let transform = transform else {
            return
        }
        guard transform.usesProposedPosition == false else {
            return
        }
        
        transform.currentPosition = transform.initialPosition + colliderSize / 2
    }
    
    private func updateColliderSize(for scene: GlideScene) {
        guard adjustsColliderSize else {
            return
        }
        guard let collider = entity?.component(ofType: ColliderComponent.self) else {
            return
        }
        collider.size = CGSize(width: collider.size.width, height: scene.size.height - (transform?.initialPosition.y ?? 0))
    }
    
    private lazy var debugNode: SKSpriteNode = {
        let debugNodeName = debugElementName(with: "checkpoint")
        let debugSprite = SKSpriteNode(color: Color.yellow.withAlphaComponent(0.3), size: .zero)
        debugSprite.name = debugNodeName
        return debugSprite
    }()
}

extension CheckpointComponent: DebuggableComponent {
    public func updateDebugElements() {
        if debugNode.parent == nil {
            transform?.node.addChild(debugNode)
        }
        let colliderSize = entity?.component(ofType: ColliderComponent.self)?.size
        debugNode.size = colliderSize ?? .zero
    }
    
    public func cleanDebugElements() {
        debugNode.removeFromParent()
    }
}

extension CheckpointComponent: NodeLayoutableComponent {
    public func layout(scene: GlideScene, previousSceneSize: CGSize) {
        updateColliderSize(for: scene)
    }
}
