//
//  ResultsViewController.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/24/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

protocol ResultsViewControllerDelegate: class {
    func fetchResults(for resultsVC: ResultsViewController)
    func isLoadingCell(_ indexPath: IndexPath) -> Bool
}
protocol ResultsViewPickerDelegate: class {
    func didSelect(_ photo: PhotoItem)
}

class ResultsViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!
    
    weak var delegate: ResultsViewControllerDelegate?
    weak var pickerDelegate: ResultsViewPickerDelegate?
    
    let viewModel = ResultsViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = nil
        collectionView.rx
            .prefetchItems
            .bind { [unowned self] indexPaths in
                guard let delegate = self.delegate else {
                    return
                }
                if indexPaths.contains(where: delegate.isLoadingCell) {
                    delegate.fetchResults(for: self)
                }
            }
            .disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(PhotoItem.self)
            .bind { self.pickerDelegate?.didSelect($0) }
            .disposed(by: disposeBag)
        
        collectionView.registerNib(class: ResultCollectionViewCell.self)
        viewModel.items.asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<Int, PhotoItem>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel<Int, PhotoItem>>(
            configureCell: { (_, table, idxPath, item) in
                let cell = table.dequeue(ResultCollectionViewCell.self, for: idxPath)
                cell.render(item, imageDriver: self.viewModel.driver(for: item))
                return cell
        })
    }
}
