//
//  GlideScene+Camera.swift
//  YAEngine
//

import SpriteKit

extension YAScene {
    
    /// Call this function to focus the camera on a specified area in the scene.
    /// Scale of the camera will be automatically arranged to fit the area in the camera.
    ///
    /// - Parameters:
    ///     - frame: Frame in the scene that the camera should focus in the next frame.
    /// Pass `nil` if the camera should no more focus on a frame.
    public func focusCamera(onFrame frame: TiledRect?) {
        if let frame = frame {
            cameraEntity.component(ofType: CameraComponent.self)?.focusFrame = frame.rect(with: tileSize)
        } else {
            cameraEntity.component(ofType: CameraComponent.self)?.focusFrame = nil
        }
    }
    
    /// Call this function to focus the camera on a specified area in the scene.
    /// Scale of the camera will be automatically arranged to fit the area in the camera.
    ///
    /// - Parameters:
    ///     - position: Position in the scene that the camera should focus in the next frame.
    /// Pass `nil` if the camera should no more focus on a frame.
    public func focusCamera(onPosition position: TiledPoint?) {
        if let position = position {
            cameraEntity.component(ofType: CameraComponent.self)?.focusPosition = position.point(with: tileSize)
        } else {
            cameraEntity.component(ofType: CameraComponent.self)?.focusPosition = nil
        }
    }
    
}
