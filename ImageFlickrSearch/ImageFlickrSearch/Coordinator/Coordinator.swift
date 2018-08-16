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
        let vc: UIViewController = {
            switch item {
            case .search:
                return instantiateSearchViewController(with: splitVC.displayModeButtonItem)
            case .popular:
                return instantiatePopularViewController(with: splitVC.displayModeButtonItem)
            }
        }()
        vc.title = item.description
        splitVC.showDetailViewController(vc, sender: nil)
    }
    
    func instantiateSearchViewController(with leftBarButtonItem: UIBarButtonItem) -> SearchViewController {
        let vc = SearchViewController()
        vc.navigationItem.leftBarButtonItem = leftBarButtonItem
        vc.navigationItem.leftItemsSupplementBackButton = true
        return vc
    }
    
    func instantiatePopularViewController(with leftBarButtonItem: UIBarButtonItem) -> PopularViewController {
        let vc = PopularViewController()
        vc.navigationItem.leftBarButtonItem = leftBarButtonItem
        vc.navigationItem.leftItemsSupplementBackButton = true
        return vc
    }
}
