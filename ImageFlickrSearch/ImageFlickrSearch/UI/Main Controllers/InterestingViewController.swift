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

class InterestingViewController: UIViewController, ContentViewController {
    typealias ViewModelType = InterestingViewModel
    
    let viewModel = InterestingViewModel()
    let disposeBag = DisposeBag()
    
    var resultsVC = ResultsViewController()
    var noResultsVC = EmptyStateViewController()
    var loadingVC = LoadingViewController()
    weak var delegate: ContentViewControllerDelegate?
    
    @IBOutlet var resultContainerView: UIView!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadChildControllers()
        resultsVC.pickerDelegate = self
        
        let resultQuery: Observable<PhotoItemsCollection> = Observable<Void>.just(())
            .flatMap({ _ -> Observable<PhotoItemsCollection> in
                // check if child view controller is already loaded
                guard let trigger = self.resultsVC.triggerObservable else { return Observable.empty() }
                return self.viewModel.load(loadTrigger: trigger)
            })
            .map { $0 }
            .share()
        
        resultQuery.asDriver(onErrorJustReturn: PhotoItemsCollection(items: nil, searchTerm: ""))
            .drive(resultsVC.viewModel.resultItems)
            .disposed(by: disposeBag)
        resultQuery.asDriver(onErrorJustReturn: PhotoItemsCollection(items: nil, searchTerm: ""))
            .drive(onNext: { items in
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
extension InterestingViewController: ResultsViewPickerDelegate {
    func didSelect(_ photo: PhotoItem) {
        delegate?.didSelect(photo)
    }
}
