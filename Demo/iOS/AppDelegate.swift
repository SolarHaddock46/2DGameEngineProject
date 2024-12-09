//
//  AppDelegate.swift
//  YAEngine Demo
//


import UIKit
import YAEngine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate {
        // swiftlint:disable:next force_cast
        return UIApplication.shared.delegate as! AppDelegate
    }
    var window: UIWindow?
    var containerViewController: ContainerViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ComponentPriorityRegistry.shared.prettyPrintPriorityList()
        TransformNodeComponent.isDebugEnabled = true
        ColliderComponent.isDebugEnabled = true
        EntityObserverComponent.isDebugEnabled = true
        CheckpointComponent.isDebugEnabled = true
        //CameraComponent.isDebugEnabled = true
        
        containerViewController = window?.rootViewController as? ContainerViewController
        containerViewController?.loadViewIfNeeded()
        let viewModel = LevelSectionsViewModel()
        let levelsViewController = LevelSectionsViewController(viewModel: viewModel)
        containerViewController?.placeContentViewController(levelsViewController)
        
        return true
    }    
}
