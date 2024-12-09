//
//  ViewController.swift
//  YAEngine
//

#if os(OSX)
import AppKit.NSViewController
public typealias ViewControllerType = NSViewController
#else
import UIKit.UIViewController
public typealias ViewControllerType = UIViewController
#endif

extension ViewControllerType {
    public func addChild(_ childViewController: ViewControllerType, in containerView: View) {
        addChild(childViewController)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        childViewController.view.frame = containerView.bounds
        containerView.addSubview(childViewController.view)
        NSLayoutConstraint.activate([
            childViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            childViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
    }
    
    public func addChild(_ childViewController: ViewControllerType, with layoutGuide: LayoutGuide) {
        addChild(childViewController)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childViewController.view)
        NSLayoutConstraint.activate([
            childViewController.view.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            childViewController.view.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
            ])
    }
}
