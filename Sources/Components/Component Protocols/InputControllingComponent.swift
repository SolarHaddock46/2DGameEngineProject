//
//  InputControllingComponent.swift
//  YAEngine
//

import Foundation

/// When adopted, a component can decide if its entity's components are
/// allowed to process inputs.
/// `shouldBlockInputs` property of the entity should be used by each
/// component that want to skip processing inputs.
public protocol InputControllingComponent {
    
    /// `true` if entity's component should not process user inputs.
    var shouldBlockInputs: Bool { get }
}
