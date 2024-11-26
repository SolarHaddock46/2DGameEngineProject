//
//  AppDelegate.swift
//  glide Demo
//
//  Copyright (c) 2019 cocoatoucher user on github.com (https://github.com/cocoatoucher/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
