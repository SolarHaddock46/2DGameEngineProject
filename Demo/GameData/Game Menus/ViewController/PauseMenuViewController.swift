//
//  PauseMenuViewController.swift
//  YAEngine Demo
//


import YAEngine
import UIKit

protocol PauseMenuViewControllerDelegate: AnyObject {
    func pauseMenuViewControllerDidSelectResume(_ pauseMenuViewController: PauseMenuViewController)
    func pauseMenuViewControllerDidSelectRestart(_ pauseMenuViewController: PauseMenuViewController)
    func pauseMenuViewControllerDidSelectMainMenu(_ pauseMenuViewController: PauseMenuViewController)
}

class PauseMenuViewController: NavigatableViewController {
    
    weak var delegate: PauseMenuViewControllerDelegate?
    
    var containerView: View = {
        let view = View()
        view.backgroundColor = Color.hudBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.cornerRadius = 4.0
        view.clipsToBounds = true
        return view
    }()
    var buttonsContainerLayoutGuide: LayoutGuide = {
        let layoutGuide = LayoutGuide()
        return layoutGuide
    }()
    
    lazy var overlayView: OverlayView = {
        let view = OverlayView()
        view.autoresizingMask = [View.AutoresizingMask.flexibleWidth, View.AutoresizingMask.flexibleHeight]
        return view
    }()
    
    let displaysResume: Bool
    
    init(displaysResume: Bool) {
        self.displaysResume = displaysResume
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pause"
        
        setupViews()
        setupNavigationElements()
    }
    
    func setupViews() {
        overlayView.frame = view.bounds
        view.addSubview(overlayView)
        
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        view.addLayoutGuide(buttonsContainerLayoutGuide)
        NSLayoutConstraint.activate([
            buttonsContainerLayoutGuide.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            buttonsContainerLayoutGuide.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            buttonsContainerLayoutGuide.topAnchor.constraint(equalTo: containerView.topAnchor),
            buttonsContainerLayoutGuide.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
    }
    
    func setupNavigationElements() {
        let buttonsViewController = NavigatablePopoverViewController()
        if displaysResume {
            buttonsViewController.addAction(contentView: PopoverActionButtonContentView(title: "Resume")) { [weak self] in
                guard let self = self else {
                    return
                }
                self.delegate?.pauseMenuViewControllerDidSelectResume(self)
            }
        }
        buttonsViewController.addAction(contentView: PopoverActionButtonContentView(title: "Restart")) { [weak self] in
            guard let self = self else {
                return
            }
            self.delegate?.pauseMenuViewControllerDidSelectRestart(self)
        }
        buttonsViewController.addAction(contentView: PopoverActionButtonContentView(title: "Main Menu")) { [weak self] in
            guard let self = self else {
                return
            }
            self.delegate?.pauseMenuViewControllerDidSelectMainMenu(self)
        }
        
        addNavigatableChild(buttonsViewController, with: buttonsContainerLayoutGuide)
        
        firstResponderChild = buttonsViewController
    }
}
