//
//  CreditsViewController.swift
//  YAEngine Demo
//


import YAEngine
#if os(OSX)
import AppKit
#else
import UIKit
#endif

class CreditsViewController: NavigatableViewController {
    
    lazy var backButton: NavigatableButton = {
        let button = NavigatableButton()
        button.contentView = ActionButtonContentView(title: "Back")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var label: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.maximumNumberOfLines = 0
        label.font = Font.headerTextFont(ofSize: menuHeaderFontSize)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let universalView = view as? View else {
            return
        }
        
        universalView.backgroundColor = Color.mainBackgroundColor
        label.text =
        """
        A demo game for YAEngine, a basic custom platformer game engine
        built on SpriteKit and GameplayKit.
        
        Created by Vladimir Matsnev
        in MIEM, Moscow
        (c) 2024 Vladimir Matsnev
        """
        
        view.addSubview(label)
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: universalView.safeAreaCenterXAnchor),
            label.centerYAnchor.constraint(equalTo: universalView.safeAreaCenterYAnchor),
            backButton.trailingAnchor.constraint(equalTo: universalView.safeAreaTrailingAnchor, constant: -20.0),
            backButton.topAnchor.constraint(equalTo: universalView.safeAreaTopAnchor, constant: 20.0)
            ])
        
        append(children: [backButton])
        
        cancelHandler = { [weak self] context in
            self?.handleCancel()
        }
    }
    
    override func didSelect(focusedChild: NavigatableElement?, context: Any?) {
        if focusedChild === backButton {
            handleCancel()
        }
    }
    
    private func handleCancel() {
        let viewModel = LevelSectionsViewModel()
        let mainMenu = LevelSectionsViewController(viewModel: viewModel)
        AppDelegate.shared.containerViewController?.placeContentViewController(mainMenu)
    }
    
    override func animateCancel(completion: @escaping () -> Void) {
        backButton.animateSelect {
            completion()
        }
    }
}
