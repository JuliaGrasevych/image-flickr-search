//
//  Coordinator.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/23/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation
import UIKit

class Coordinator {
    private let splitVC: UISplitViewController
    init(split: UISplitViewController) {
        splitVC = split
        let navVC = split.viewControllers.first as? UINavigationController
        let menuVC = navVC?.viewControllers.first as? MasterViewController
        menuVC?.delegate = self
    }
}

extension Coordinator: MenuItemControllerDelegate {
    func didSelect(_ item: MenuItem) {
        let viewController: UIViewController = {
            switch item {
            case .search:
                return instantiateSearchViewController(with: splitVC.displayModeButtonItem)
            case .popular:
                return instantiatePopularViewController(with: splitVC.displayModeButtonItem)
            }
        }()
        viewController.title = item.description
        splitVC.showDetailViewController(viewController, sender: nil)
    }
    
    func instantiateSearchViewController(with leftBarButtonItem: UIBarButtonItem) -> SearchViewController {
        let viewController = SearchViewController()
        viewController.navigationItem.leftBarButtonItem = leftBarButtonItem
        viewController.navigationItem.leftItemsSupplementBackButton = true
        return viewController
    }
    
    func instantiatePopularViewController(with leftBarButtonItem: UIBarButtonItem) -> PopularViewController {
        let viewController = PopularViewController()
        viewController.navigationItem.leftBarButtonItem = leftBarButtonItem
        viewController.navigationItem.leftItemsSupplementBackButton = true
        return viewController
    }
}
