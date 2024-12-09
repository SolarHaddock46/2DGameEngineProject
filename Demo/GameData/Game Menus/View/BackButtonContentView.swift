//
//  ActionButtonContentView.swift
//  YAEngine Demo
//


import YAEngine
import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

class ActionButtonContentView: SelectionButtonContentView {
    
    lazy var imageView: ImageView = {
        let imageView = ImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var label: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.actionButtonTextFont(ofSize: actionButtonFontSize)
        return label
    }()
    
    init(title: String) {
        super.init(normalBackgroundColor: Color.backButtonBackgroundColor)
        
        label.text = title
        label.textColor = Color.backButtonTextColor
        addSubview(label)
        addSubview(imageView)
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -5.0),
            label.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 5.0),
            label.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -5.0),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5.0),
            imageView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 5.0),
            imageView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor)
            ])
    }
}
