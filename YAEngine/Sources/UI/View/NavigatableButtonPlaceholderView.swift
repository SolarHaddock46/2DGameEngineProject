//
//  NavigatableButtonPlaceholderView.swift
//  YAEngine
//

import Foundation
import CoreGraphics

/// Represents an empty view that is used as a spacer next to other navigatable buttons
/// typically in a navigatable scroll view.
class NavigatableButtonPlaceholderView: View {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
