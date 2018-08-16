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
    
    var resultsVC: ResultsViewController = ResultsViewController()
    var noResultsVC: EmptyStateViewController = EmptyStateViewController()
    var loadingVC: LoadingViewController = LoadingViewController()
    
    var viewModel: SearchViewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            .map({ return $0?.items })
            .bind(to: resultsVC.viewModel.resultItems)
            .disposed(by: self.disposeBag)
    }
}
