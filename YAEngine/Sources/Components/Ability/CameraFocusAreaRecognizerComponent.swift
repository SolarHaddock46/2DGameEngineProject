//
//  CameraFocusAreaRecognizerComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that gives an entity the ability to be trigger camera focus
/// on specified areas. When an entity with this component establishes
/// contact with a camera focus area, camera will automatically focus on this
/// area.
public final class CameraFocusAreaRecognizerComponent: GKComponent, YAComponent {
    public static let componentPriority: Int = 620
}
