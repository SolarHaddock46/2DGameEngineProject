//
//  ActionsEvaluatorComponent.swift
//  YAEngine
//

import Foundation

/// When adopted, component will be informed of SKScene's `didEvaluateActions()`.
/// Can be used by components that want to perform logic after the actions in
/// the scene has done processing.
/// `TextureAnimatorComponent` is an example component for this.
protocol ActionsEvaluatorComponent {
    
    /// Called after SKScene's `didEvaluateActions()` is called.
    /// Don't call this method directly.
    func sceneDidEvaluateActions()
}
