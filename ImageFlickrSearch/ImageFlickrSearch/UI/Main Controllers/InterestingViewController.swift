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
        resultsVC.delegate = self
        resultsVC.pickerDelegate = self
        
        Driver.just("Loading...")
            .drive(loadingVC.viewModel.text)
            .disposed(by: disposeBag)
        
        viewModel.state
            .drive(onNext: { self.setupResults(state: $0) })
            .disposed(by: disposeBag)
        
        viewModel.items.asDriver()
            .drive(resultsVC.viewModel.resultItems)
            .disposed(by: disposeBag)
    }
}

// MARK: - ResultsViewControllerDelegate
extension InterestingViewController: ResultsViewControllerDelegate {
    func fetchResults(for resultsVC: ResultsViewController) {
        viewModel.moreResults()
    }
    
    func isLoadingCell(_ indexPath: IndexPath) -> Bool {
        return viewModel.fullyLoaded
            ? false
            : indexPath.row >= viewModel.currentCount - 1
    }
}

// MARK: - ResultsViewPickerDelegate
extension InterestingViewController: ResultsViewPickerDelegate {
    func didSelect(_ photo: PhotoItem) {
        delegate?.didSelect(photo)
    }
}
