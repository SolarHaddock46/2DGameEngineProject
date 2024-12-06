//
//  PopoverActionButtonContentView.swift
//  glide Demo
//


import YAEngine
#if os(OSX)
import AppKit
#else
import UIKit
#endif

class PopoverActionButtonContentView: SelectionButtonContentView {
    
    lazy var label: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.defaultTextColor
        label.font = Font.actionButtonTextFont(ofSize: actionButtonFontSize)
        label.textAlignment = .center
        return label
    }()
    
    init(title: String) {
        super.init(normalBackgroundColor: .clear)
        
        label.text = title
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            label.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor)
            ])
    }
}
