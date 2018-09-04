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
    @IBOutlet private var label: UILabel!
    @IBOutlet private var imageView: ImageInfoView!
    
    private var driverDisposable: Disposable?
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        imageView.update(state: .empty)
        label.text = nil
    }
    
    func render(_ item: PhotoItem, imageDriver: Driver<UIImage?>) {
        label.text = item.title
        handle(driver: imageDriver)
    }
    
    private func handle(driver: Driver<UIImage?>) {
        imageView.update(state: .loading)
        driverDisposable?.dispose()
        driverDisposable = driver.asObservable()
            .subscribe(onNext: { imageIcon in
                self.imageView.update(state: .loaded(imageIcon))
            }, onError: { error in
                // handle error
                self.imageView.update(state: .error("Oops!"))
            })
        driverDisposable?.disposed(by: disposeBag)
    }
}
