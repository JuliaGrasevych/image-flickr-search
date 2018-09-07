//
//  SearchViewController.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/24/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController, ContentViewController {
    typealias ViewModelType = SearchViewModel

    @IBOutlet var resultContainerView: UIView!
    @IBOutlet private var searchField: UISearchBar!
    
    var resultsVC = ResultsViewController()
    var noResultsVC = EmptyStateViewController()
    var loadingVC = LoadingViewController()
    weak var delegate: ContentViewControllerDelegate?
    
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsVC.delegate = self
        resultsVC.pickerDelegate = self
        
        viewModel.state
            .drive(onNext: { state in
                self.setupResults(state: state)
            })
            .disposed(by: disposeBag)
        // Should this be declared in viewModel ?
        viewModel.state
            .filter { $0 == .empty || $0 == .default }
            .map { state -> String in
                if state == .default {
                    return "Type at least 3 symbols to start search"
                }
                return "No results"
            }
            .drive(noResultsVC.viewModel.description)
            .disposed(by: disposeBag)
        
        searchField.rx.text
            .asDriver()
            .drive(viewModel.searchTerm)
            .disposed(by: disposeBag)
        
        viewModel.searchTerm.asDriver()
            .map { value -> String? in
                if let value = value {
                    return "Search for \"\(value)\""
                }
                return nil
            }
            .drive(loadingVC.viewModel.text)
            .disposed(by: self.disposeBag)
        
        viewModel.items.asDriver()
            .drive(resultsVC.viewModel.resultItems)
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
extension SearchViewController: ResultsViewPickerDelegate {
    func didSelect(_ photo: PhotoItem) {
        delegate?.didSelect(photo)
    }
}
