//
//  FocusableComponent.swift
//  YAEngine
//

import GameplayKit

/// Component that makes an entity controllable by the focusables controller
/// of a scene.
/// See `FocusableEntitiesControllerComponent`.
public final class FocusableComponent: GKComponent, GlideComponent {
    
    /// `true` if the entity of this component should become focused among
    /// its sibling focusables.
    public private(set) var isFirstFocusable: Bool = false
    
    /// Entity with `FocusableComponent` on the left side of this component's entity
    /// in screen coordinates.
    public var leftwardFocusable: FocusableComponent?
    
    /// Entity with `FocusableComponent` on the right side of this component's entity
    /// in screen coordinates.
    public var rightwardFocusable: FocusableComponent?
    
    /// Entity with `FocusableComponent` on the top of this component's entity
    /// in screen coordinates.
    public var upwardFocusable: FocusableComponent?
    
    /// Entity with `FocusableComponent` on the bottom of this component's entity
    /// in screen coordinates.
    public var downwardFocusable: FocusableComponent?
    
    /// `true` if the entity was focused in the last frame.
    public private(set) var wasFocused: Bool = false
    
    /// `true` if the entity is focused in the current frame.
    public internal(set) var isFocused: Bool = false
    
    /// `true` if the entity was sent a select event in the last frame.
    public private(set) var wasSelected: Bool = false
    
    /// `true` if the entity is sent a select event in the current frame.
    public internal(set) var isSelected: Bool = false
    
    /// `true` if the entity was sent a cancel event in the last frame.
    public private(set) var wasCancelled: Bool = false
    
    /// `true` if the entity is sent a cancel event in the current frame.
    public internal(set) var isCancelled: Bool = false
    
    /// Name of the input profile to use as the selection event for this focusable.
    public let selectionInputProfile: String
    
    // MARK: - Initialize
    
    /// Create a focusable component.
    ///
    /// - Parameters:
    ///     - selectionInputProfile: Name of the input profile to use as the selection event
    /// for this focusable.
    public init(selectionInputProfile: String) {
        self.selectionInputProfile = selectionInputProfile
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FocusableComponent: StateResettingComponent {
    public func resetStates() {
        wasFocused = isFocused
        wasSelected = isSelected
        wasCancelled = isCancelled
        
        isSelected = false
        isCancelled = false
    }
}
