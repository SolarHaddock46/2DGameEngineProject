//
//  LevelThumbView.swift
//  glide Demo
//


import SpriteKit
import YAEngine
#if os(OSX)
import AppKit
#else
import UIKit
#endif

class LevelThumbView: SelectionButtonContentView {
    
    let viewModel: LevelThumbViewModel
    let label = Label()
    let imageView = ImageView()
    
    init(viewModel: LevelThumbViewModel) {
        self.viewModel = viewModel
        super.init(normalBackgroundColor: Color.levelThumbBackgroundColor)
        
        imageView.image = Image(named: "level_thumb")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        label.setContentHuggingPriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.vertical)
        label.setContentHuggingPriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.horizontal)
        label.setContentCompressionResistancePriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.vertical)
        label.setContentCompressionResistancePriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.horizontal)
        
        #if !os(OSX)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.clipsToBounds = true
        #endif
        imageView.setContentHuggingPriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.vertical)
        imageView.setContentHuggingPriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.horizontal)
        imageView.setContentCompressionResistancePriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.vertical)
        imageView.setContentCompressionResistancePriority(LayoutConstraint.Priority.defaultLow, for: LayoutConstraint.Orientation.horizontal)
        
        label.text = viewModel.levelName
        #if os(iOS)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        #endif
        label.font = Font.subheaderTextFont(ofSize: levelTitleFontSize)
        label.textColor = Color.defaultTextColor
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.maximumNumberOfLines = 0
        addSubview(label)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 5.0),
            imageView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: safeAreaGuide.heightAnchor, multiplier: 0.6),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            label.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -5.0),
            label.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 5.0),
            label.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -5.0)
            ])
    }
}
