//
//  PopularViewController.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/24/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit

class PopularViewController: UIViewController, CommonViewController {
    typealias ViewModelType = PopularViewModel
    
    @IBOutlet var resultContainerView: UIView!
    
    var resultsVC = ResultsViewController()
    var noResultsVC = EmptyStateViewController()
    var loadingVC = LoadingViewController()
    var viewModel = PopularViewModel()
}
