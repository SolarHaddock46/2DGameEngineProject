//
//  SceneAnchoredSpriteLayoutComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that is used to layout its entity's sprite node with given
/// layout constraints that can be setup related to scene dimensions.
/// It's recommended to use this component for entities that are not a child of the scene's
/// camera(thus, not a part of gameplay) but should render UI related nodes like text,
/// buttons and background images.
/// This component makes those entities' nodes independent from camera's scaling and fixes
/// their layout in respect to screen dimensions.
///
/// Required components: `SpriteNodeComponent`.
public final class SceneAnchoredSpriteLayoutComponent: GKComponent, YAComponent {
    
    public static let componentPriority: Int = 400
    
    /// Layout constraint for the width of the sprite.
    public var widthConstraint: NodeLayoutConstraint = .proportionalToSceneSize(1.0)
    
    /// Layout constraint for the height of the sprite.
    public var heightConstraint: NodeLayoutConstraint = .proportionalToSceneSize(1.0)
    
    /// Layout constraint for the x position of the sprite.
    public var xOffsetConstraint: NodeLayoutConstraint = .constant(0.0)
    
    /// Layout constraint for the y position of the sprite.
    public var yOffsetConstraint: NodeLayoutConstraint = .constant(0.0)
    
    /// `true` if the entity's transform is scaled matching the scane of the scene's camera.
    /// Default value is `true`.
    public var scalesTransformWithTheCamera: Bool = true
    
    public func start() {
        guard let scene = scene else {
            return
        }
        layoutSprite(scene: scene)
        
        applyScaleIfNeeded()
    }
    
    public func updateAfterCameraUpdate(deltaTime seconds: TimeInterval, cameraComponent: CameraComponent) {
        applyScaleIfNeeded()
    }
    
    // MARK: - Private
    
    private func layoutSprite(scene: GlideScene) {
        guard let spriteNodeComponent = entity?.component(ofType: SpriteNodeComponent.self) else {
            return
        }
        spriteNodeComponent.spriteNode.size = spriteSize(for: scene.size)
        spriteNodeComponent.offset = spriteOffset(for: scene.size)
    }
    
    private func spriteSize(for sceneSize: CGSize) -> CGSize {
        var width: CGFloat
        switch widthConstraint {
        case .constant(let constant):
            width = constant
        case .proportionalToSceneSize(let multiplier):
            width = sceneSize.width * multiplier
        }
        
        var height: CGFloat
        switch heightConstraint {
        case .constant(let constant):
            height = constant
        case .proportionalToSceneSize(let multiplier):
            height = sceneSize.height * multiplier
        }
        
        return CGSize(width: width, height: height)
    }
    
    private func spriteOffset(for sceneSize: CGSize) -> CGPoint {
        var horizontalOffset: CGFloat
        switch xOffsetConstraint {
        case .constant(let constant):
            horizontalOffset = constant
        case .proportionalToSceneSize(let multiplier):
            horizontalOffset = sceneSize.width * multiplier
        }
        
        var verticalOffset: CGFloat
        switch yOffsetConstraint {
        case .constant(let constant):
            verticalOffset = constant
        case .proportionalToSceneSize(let multiplier):
            verticalOffset = sceneSize.height * multiplier
        }
        
        return CGPoint(x: horizontalOffset, y: verticalOffset)
    }
    
    private func applyScaleIfNeeded() {
        guard let cameraNode = scene?.camera else {
            return
        }
        
        if scalesTransformWithTheCamera {
            transform?.node.xScale = cameraNode.xScale
            transform?.node.yScale = cameraNode.yScale
        }
    }
}

extension SceneAnchoredSpriteLayoutComponent: NodeLayoutableComponent {
    public func layout(scene: GlideScene, previousSceneSize: CGSize) {
        guard scene.size != previousSceneSize || transform?.node.xScale != scene.camera?.xScale else {
            return
        }
        layoutSprite(scene: scene)
    }
}
