//
//  ContentViewController.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/24/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit

protocol ContentViewControllerDelegate: class {
    func didSelect(_ photo: PhotoItem)
}

protocol ContentViewController where Self: UIViewController {
    associatedtype ViewModelType
    
    var resultContainerView: UIView! { get set }
    var resultsVC: ResultsViewController { get set }
    var noResultsVC: EmptyStateViewController { get set }
    var loadingVC: LoadingViewController { get set }
    var viewModel: ViewModelType { get }
    var delegate: ContentViewControllerDelegate? { get set }
    
    func setupResults(state: ContentState)
}

extension ContentViewController {
    func setupResults(state: ContentState) {
        switch state {
        case .default:
            setupChild(viewController: noResultsVC)
        case .empty:
            setupChild(viewController: noResultsVC)
        case .loading:
            setupChild(viewController: loadingVC)
        case .loaded:
            setupChild(viewController: resultsVC)
        }
    }
    
    func setupChild(viewController: UIViewController) {
        guard let vcView = viewController.view else {
            debugPrint("Couldn't instantiate view")
            return
        }
        guard vcView.superview != view else {
            view.bringSubview(toFront: vcView)
            debugPrint("\(type(of: viewController)) is already a child for this view controller. Just bring its view to front.")
            return
        }
        vcView.translatesAutoresizingMaskIntoConstraints = false
        resultContainerView.addSubview(vcView)
        let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: "H:|[resultView]|",
                                                          options: .alignAllLeading,
                                                          metrics: nil,
                                                          views: ["resultView": vcView])
        let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[resultView]|",
                                                          options: .alignAllLeading,
                                                          metrics: nil,
                                                          views: ["resultView": vcView])
        NSLayoutConstraint.activate(constraintsH + constraintsV)
        addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
    }
}
