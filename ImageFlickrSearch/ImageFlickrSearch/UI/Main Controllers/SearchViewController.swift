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
    
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    var resultsVC = ResultsViewController()
    var noResultsVC = EmptyStateViewController()
    var loadingVC = LoadingViewController()
    weak var delegate: ContentViewControllerDelegate?
    
    @IBOutlet var resultContainerView: UIView!
    @IBOutlet private var searchField: UISearchBar!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadChildControllers()
        resultsVC.pickerDelegate = self
        
        let resultQuery: Observable<PhotoItemsCollection?> = searchField.rx.text
            .orEmpty
            .changed
            .filter { $0.count > 2 }
            .debounce(1, scheduler: MainScheduler.instance)
            .flatMap { text -> Observable<PhotoItemsCollection> in
                // check if child view controller is already loaded
                guard let trigger = self.resultsVC.triggerObservable else { return Observable.empty() }
                return self.viewModel.search(text, loadTrigger: trigger)
            }
            .map { $0 }
            .share()
        
        resultQuery.asDriver(onErrorJustReturn: PhotoItemsCollection(items: nil, searchTerm: ""))
            .drive(resultsVC.viewModel.resultItems)
            .disposed(by: disposeBag)
        resultQuery.asDriver(onErrorJustReturn: PhotoItemsCollection(items: nil, searchTerm: ""))
            .startWith(nil)
            .drive(onNext: { items in
                guard let items = items else {
                    self.setupResults(state: .default(message: "Type at least 3 symbols to start search"))
                    return
                }
                if let count = items.count, count > 0 {
                    self.setupResults(state: .loaded)
                } else {
                    self.setupResults(state: .empty(message: "No results"))
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - ResultsViewPickerDelegate
extension SearchViewController: ResultsViewPickerDelegate {
    func didSelect(_ photo: PhotoItem) {
        delegate?.didSelect(photo)
    }
}
