//
//  AppDelegate.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/23/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let splitViewController = window!.rootViewController as? UISplitViewController {
            splitViewController.preferredDisplayMode = .allVisible
            splitViewController.delegate = self
            coordinator = Coordinator(split: splitViewController)
        }
        return true
    }

    // MARK: - Split view
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard secondaryAsNavController.topViewController != nil else { return true }
        return false
    }

}
