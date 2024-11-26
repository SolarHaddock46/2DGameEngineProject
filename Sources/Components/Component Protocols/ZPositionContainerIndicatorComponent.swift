//
//  ZPositionContainerIndicatorComponent.swift
//  YAEngine
//

import Foundation

/// When adopted, a component can specify which z position container
/// its entity's transform node should use as a parent.
/// If multiple components of an entity specify a z position container
/// only the container specified by the component with the lowest
/// `componentPriority` is taken into account.
public protocol ZPositionContainerIndicatorComponent {
    
    /// Order container that this component's transform node should
    /// be placed in.
    var zPositionContainer: ZPositionContainer? { get set }
}
