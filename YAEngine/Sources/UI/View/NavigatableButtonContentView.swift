//
//  NavigatableButtonContentView.swift
//  YAEngine
//

import Foundation

/// Protocol to adopt for custom content view classes of navigatable buttons.
public protocol NavigatableButtonContentView: AnyObject {
    var isSelected: Bool { get set }
    var isFocusedElement: Bool { get set }
    var isTouchedDown: Bool { get set }
    func animateSelect(completion: @escaping () -> Void)
}
