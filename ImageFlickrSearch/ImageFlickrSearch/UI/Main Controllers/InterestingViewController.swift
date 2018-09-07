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
    
    @IBOutlet var resultContainerView: UIView!
    
    var resultsVC = ResultsViewController()
    var noResultsVC = EmptyStateViewController()
    var loadingVC = LoadingViewController()
    weak var delegate: ContentViewControllerDelegate?
    
    let viewModel = InterestingViewModel()
    let disposeBag = DisposeBag()
    
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
extension InterestingViewController: ResultsViewPickerDelegate {
    func didSelect(_ photo: PhotoItem) {
        delegate?.didSelect(photo)
    }
}
