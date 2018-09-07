//
//  ResultCollectionViewCell.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/16/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ResultCollectionViewCell: UICollectionViewCell {
    private let disposeBag = DisposeBag()
    
    private var driverDisposable: Disposable?
    @IBOutlet private var label: UILabel!
    @IBOutlet private var imageView: ImageInfoView!

    // MARK: - View lifecycle
    override func prepareForReuse() {
        imageView.update(state: .empty)
        label.text = nil
    }
    // MARK: - Public methods
    func render(_ item: PhotoItem, imageDriver: Driver<UIImage?>) {
        label.text = item.title
        handle(driver: imageDriver)
    }
    // MARK: - Private methods
    private func handle(driver: Driver<UIImage?>) {
        imageView.update(state: .loading)
        driverDisposable?.dispose()
        driverDisposable = driver
            .drive(onNext: { self.imageView.update(state: .loaded($0)) })
        driverDisposable?.disposed(by: disposeBag)
    }
}
