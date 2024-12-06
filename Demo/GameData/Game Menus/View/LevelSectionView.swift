//
//  LevelSectionView.swift
//  glide Demo
//


import SpriteKit
import YAEngine
#if os(OSX)
import AppKit
#else
import UIKit
#endif

class LevelSectionView: SelectionButtonContentView {
    
    let viewModel: SingleLevelSectionViewModel
    let label = Label()
    let imageView = ImageView()
    
    init(viewModel: SingleLevelSectionViewModel) {
        self.viewModel = viewModel
        super.init(normalBackgroundColor: .clear)
        
        label.text = viewModel.section.name
        label.maximumNumberOfLines = 1
        #if os(iOS)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        #endif
        label.font = Font.headerTextFont(ofSize: menuHeaderFontSize)
        label.textColor = Color.defaultTextColor
        imageView.image = Image(imageLiteralResourceName: "star")
        
        imageView.setContentCompressionResistancePriority(LayoutConstraint.Priority.required, for: LayoutConstraint.Orientation.horizontal)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 10.0),
            imageView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaGuide.topAnchor),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaGuide.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10.0),
            label.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaGuide.trailingAnchor, constant: -10)
            ])
    }
}
