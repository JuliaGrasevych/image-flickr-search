//
//  PopularViewController.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/24/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InterestingViewController: UIViewController, CommonViewController {
    typealias ViewModelType = InterestingViewModel
    
    @IBOutlet var resultContainerView: UIView!
    
    var resultsVC = ResultsViewController()
    var noResultsVC = EmptyStateViewController()
    var loadingVC = LoadingViewController()
    var viewModel = InterestingViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsVC.delegate = self
        Observable.just("Loading...")
            .bind(to: loadingVC.viewModel.text)
            .disposed(by: disposeBag)
        
        viewModel.state
            .subscribe(onNext: { state in
                self.setupResults(state: state)
            })
            .disposed(by: disposeBag)
        
        viewModel.items.asObservable()
            .bind(to: resultsVC.viewModel.resultItems)
            .disposed(by: disposeBag)
    }
}

extension InterestingViewController: ResultsViewControllerDelegate {
    func fetchResults(for resultsVC: ResultsViewController) {
        viewModel.moreResults()
    }
    
    func isLoadingCell(_ indexPath: IndexPath) -> Bool {
        guard !viewModel.fullyLoaded else {
            return false
        }
        return indexPath.row >= viewModel.currentCount - 1
    }
    
    
}
