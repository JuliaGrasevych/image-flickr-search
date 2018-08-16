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
    
    var resultsVC: ResultsViewController = ResultsViewController()
    var noResultsVC: EmptyStateViewController = EmptyStateViewController()
    var loadingVC: LoadingViewController = LoadingViewController()
    var viewModel: PopularViewModel = PopularViewModel()
}
