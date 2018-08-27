//
//  ResultsViewModel.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/16/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class ResultsViewModel {
    private let httpClient = FlickrHTTPClient()
    var items: Observable<[SectionModel<Int, PhotoItem>]> {
        return resultItems.asObservable()
            .map({ $0?.items })
            .filter({ $0 != nil })
            .map { items in
            return [SectionModel(model: 0, items: items!)]
        }
    }
    
    let resultItems: Variable<PhotoItemsCollection?> = Variable(nil)
    
    func driver(for item: PhotoItem) -> Driver<UIImage?> {
        guard let url = item.url else {
            return Driver.just(nil)
        }
        return httpClient.rx_image(url: url)
    }
}
