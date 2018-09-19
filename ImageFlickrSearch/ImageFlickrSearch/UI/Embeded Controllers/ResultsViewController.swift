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

protocol ResultsViewPickerDelegate: class {
    func didSelect(_ photo: PhotoItem)
}

class ResultsViewController: UIViewController {
    let viewModel = ResultsViewModel()
    weak var pickerDelegate: ResultsViewPickerDelegate?
    
    var triggerObservable: Observable<Void>?
    
    private let disposeBag = DisposeBag()
    @IBOutlet private var collectionView: UICollectionView!
    private var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<Int, PhotoItem>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel<Int, PhotoItem>>(
            configureCell: { (_, table, idxPath, item) in
                let cell = table.dequeue(ResultCollectionViewCell.self, for: idxPath)
                cell.render(item, imageDriver: self.viewModel.driver(for: item))
                return cell
        })
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = nil
        triggerObservable = collectionView.rx
            .prefetchItems
            .filter { indexPaths in
                let count = self.collectionView.numberOfItems(inSection: 0)
                return indexPaths.contains(where: { $0.row > count - 2 })
            }
            .map { _ in }
            .asObservable()
        
        collectionView.rx
            .modelSelected(PhotoItem.self)
            .bind { self.pickerDelegate?.didSelect($0) }
            .disposed(by: disposeBag)
        
        collectionView.registerNib(class: ResultCollectionViewCell.self)
        viewModel.items.asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
