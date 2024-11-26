//
//  NavigatablePopoverViewController.swift
//  YAEngine
//

#if os(OSX)
import AppKit
#else
import UIKit
#endif

/// View controller that displays navigatable buttons in popover style
/// and controls their input flow.
public class NavigatablePopoverViewController: NavigatableViewController {
    
    public override func loadView() {
        let popoverView = View()
        view = popoverView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.orientationAndAxis = .vertical
        stackView.spacing = 0.0
        #if os(OSX)
        stackView.distribution = NSStackView.Distribution.fillEqually
        #else
        stackView.alignment = UIStackView.Alignment.fill
        stackView.distribution = UIStackView.Distribution.fillEqually
        #endif
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
    
    /// Adds a new action to the popover. A new navigatable popover button is created
    /// with provided content view.
    ///
    /// - Parameters:
    ///     - contentView: Content view to be set for the popover button.
    ///     - handler: Callback to be executed when the button is selected.
    public func addAction(contentView: (View & NavigatableButtonContentView), handler: @escaping () -> Void) {
        let button = NavigatableButton()
        button.contentView = contentView
        addPopoverButton(button, handler: handler)
    }
    
    public override func didSelect(focusedChild: NavigatableElement?, context: Any?) {
        if let selectedButton = self.focusedChild as? NavigatableButton {
            if let index = self.buttons.firstIndex(of: selectedButton) {
                actions[index]()
            }
        }
    }
    
    // MARK: - Private
    private let stackView = StackView()
    private var buttons: [NavigatableButton] = []
    private var actions: [() -> Void] = []
    
    private func establishConnections() {
        for (index, button) in buttons.enumerated() where index + 1 < buttons.count {
            let nextButton = buttons[index + 1]
            button.downElement = nextButton
            nextButton.upElement = button
        }
    }
    
    private func addPopoverButton(_ button: NavigatableButton, handler: @escaping () -> Void) {
        buttons.append(button)
        actions.append(handler)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(LayoutConstraint.Priority.required, for: LayoutConstraint.Orientation.vertical)
        button.setContentHuggingPriority(LayoutConstraint.Priority.required, for: LayoutConstraint.Orientation.horizontal)
        button.setContentCompressionResistancePriority(LayoutConstraint.Priority.required, for: LayoutConstraint.Orientation.vertical)
        button.setContentCompressionResistancePriority(LayoutConstraint.Priority.required, for: LayoutConstraint.Orientation.horizontal)
        
        stackView.addArrangedSubview(button)
        
        append(children: [button])
        
        #if os(OSX)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: stackView.widthAnchor)
            ])
        #endif
        
        establishConnections()
    }
}
