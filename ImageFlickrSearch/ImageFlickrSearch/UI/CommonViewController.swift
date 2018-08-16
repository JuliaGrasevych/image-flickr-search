//
//  CommonViewController.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/24/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit

class CommonViewController: UIViewController {

    @IBOutlet private var resultContainerView: UIView!
    private var resultsVC: ResultsViewController = ResultsViewController()
    private var noResultsVC: EmptyStateViewController = EmptyStateViewController()
    
    func setupResults(state: CommonState) {
        DispatchQueue.main.async {
            switch state {
            case .empty:
                self.setupChild(viewController: self.noResultsVC)
            case .loading:
                break
            case .loaded:
                self.setupChild(viewController: self.resultsVC)
            }
        }
    }
    
    private func setupChild(viewController: UIViewController) {
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
        let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: "H:|[resultView]|", options: .alignAllLeading, metrics: nil, views: ["resultView": vcView])
        let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: "V:|[resultView]|", options: .alignAllLeading, metrics: nil, views: ["resultView": vcView])
        NSLayoutConstraint.activate(constraintsH + constraintsV)
        addChildViewController(viewController)
        viewController.didMove(toParentViewController: self)
    }
}
