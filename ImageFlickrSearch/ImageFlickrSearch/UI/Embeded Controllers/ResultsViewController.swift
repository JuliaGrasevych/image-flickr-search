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

class ResultsViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!
    
    let viewModel = ResultsViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = nil
        collectionView.register(UINib(nibName: "ResultCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "ResultCollectionViewCell")
        viewModel.items.asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<Int, PhotoItem>> {
        return RxCollectionViewSectionedReloadDataSource<SectionModel<Int, PhotoItem>>(
            configureCell: { (_, table, idxPath, item) in
                let cell = table.dequeueReusableCell(withReuseIdentifier: "ResultCollectionViewCell", for: idxPath) as? ResultCollectionViewCell
                cell?.render(item, imageDriver: self.viewModel.driver(for: item))
                return cell ?? UICollectionViewCell()
        })
    }
}
