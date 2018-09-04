//
//  SearchViewController.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/24/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController, CommonViewController {
    typealias ViewModelType = SearchViewModel

    @IBOutlet var resultContainerView: UIView!
    @IBOutlet private var searchField: UISearchBar!
    
    var resultsVC = ResultsViewController()
    var noResultsVC = EmptyStateViewController()
    var loadingVC = LoadingViewController()
    
    var viewModel: SearchViewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsVC.delegate = self
        
        viewModel.state
            .subscribe(onNext: { state in
                self.setupResults(state: state)
            })
            .disposed(by: disposeBag)
        
        searchField.rx.text
            .asDriver()
            .drive(viewModel.searchTerm)
            .disposed(by: disposeBag)
        
        viewModel.searchTerm.asObservable()
            .bind(to: loadingVC.viewModel.text)
            .disposed(by: self.disposeBag)
        
        viewModel.items.asObservable()
            .bind(to: resultsVC.viewModel.resultItems)
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: ResultsViewControllerDelegate {
    func fetchResults(for resultsVC: ResultsViewController) {
        viewModel.fetchResults()
    }
    func isLoadingCell(_ indexPath: IndexPath) -> Bool {
        guard !viewModel.fullyLoaded else {
            return false
        }
        return indexPath.row >= viewModel.currentCount - 1
    }
}
