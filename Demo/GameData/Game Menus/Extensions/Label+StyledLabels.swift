//
//  Label+StyledLabels.swift
//  glide Demo
//


import YAEngine
import Foundation
#if os(OSX)
import AppKit
#endif

extension Label {
    static func headerLabel(withText text: String) -> Label {
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: Color(red: 0.10, green: 0.28, blue: 0.33, alpha: 1.00),
            NSAttributedString.Key.foregroundColor: Color.white,
            NSAttributedString.Key.strokeWidth: -3.0
        ]
        
        let label = Label()
        label.attributedText = NSAttributedString(string: text, attributes: strokeTextAttributes)
        label.font = Font.headerTextFont(ofSize: 22.0)
        return label
    }
}
