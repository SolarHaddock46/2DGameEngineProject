//
//  CameraFollowerComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that makes an entity's transform follow the position of the camera
/// in a scene.
/// It is required that transform of the entity of this component has
/// `usesProposedPosition` set to `false`.
public final class CameraFollowerComponent: GKComponent, YAComponent {
    
    /// Ways to snap to the camera position.
    public enum PositionUpdateMethod {
        /// Position of the transform is updated in a linear fashion.
        /// Not providing a speed in any dimension means that the position of
        /// the transform reflects the exact position of the camera in that dimension.
        case linear(horizontalSpeed: CGFloat?, verticalSpeed: CGFloat?)
        /// Position of the transform is updated in the fashion of a slowing down spring.
        case smoothCD(smoothness: TimeInterval)
    }
    
    /// Value that indicates how the position of the transform is updated to
    /// catch up with the camera's position.
    public let positionUpdateMethod: PositionUpdateMethod
    
    // MARK: - Initialize
    
    /// Create a camera follower component.
    ///
    /// - Parameters:
    ///     - positionUpdateMethod: Value that indicates how the position of the transform
    /// is updated to catch up with the camera's position.
    public init(positionUpdateMethod: PositionUpdateMethod) {
        self.positionUpdateMethod = positionUpdateMethod
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateAfterCameraUpdate(deltaTime seconds: TimeInterval, cameraComponent: CameraComponent) {
        updatePosition(deltaTime: seconds)
    }
    
    // MARK: - Private
    
    private var smoothCDVelocity: CGPoint = .zero
    
    private func updatePosition(deltaTime seconds: TimeInterval) {
        guard let transform = transform else {
            return
        }
        guard transform.usesProposedPosition == false else {
            return
        }
        guard let camera = scene?.camera else {
            return
        }
        guard let cameraComponent = scene?.cameraEntity.component(ofType: CameraComponent.self) else {
            return
        }
        
        switch positionUpdateMethod {
        case .linear(let horizontalSpeed, let verticalSpeed):
            if let horizontalSpeed = horizontalSpeed {
                transform.currentPosition.x += (camera.position.x - cameraComponent.previousCameraPosition.x) * horizontalSpeed * CGFloat(seconds)
            } else {
                transform.currentPosition.x = camera.position.x
            }
            
            if let verticalSpeed = verticalSpeed {
                transform.currentPosition.y += (camera.position.y - cameraComponent.previousCameraPosition.y) * verticalSpeed * CGFloat(seconds)
            } else {
                transform.currentPosition.y = camera.position.y
            }
        case .smoothCD(let smoothness):
            transform.currentPosition = transform.currentPosition.smoothCD(destination: camera.position,
                                                                           velocity: &smoothCDVelocity,
                                                                           deltaTime: CGFloat(seconds),
                                                                           smoothness: CGFloat(smoothness))
        }
    }
}
