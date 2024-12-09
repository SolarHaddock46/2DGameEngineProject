//
//  CameraFocusingComponent.swift
//  YAEngine
//

import CoreGraphics

/// When adopted, a component can specify an offset value from its transform's
/// position when the camera of the scene is focused on that transform.
public protocol CameraFocusingComponent {
    
    /// Value to use as an offset from transform's position, when the camera
    /// is focusing on this component's transform.
    var focusOffset: CGPoint { get set }
}
