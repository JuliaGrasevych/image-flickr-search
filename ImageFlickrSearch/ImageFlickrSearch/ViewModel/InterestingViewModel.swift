//
//  PopularViewModel.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/25/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class InterestingViewModel {
    
    private var itemsPerPage = 10
    
    // MARK: - Public methods
    func load(page: Int = 1, loadTrigger: Observable<Void> = Observable.empty()) -> Observable<PhotoItemsCollection> {
        let searchParameters = FlickrInterestingRequest.Parameters(itemsPerPage: itemsPerPage,
                                                                   page: page)
        return load(fromList: nil, with: searchParameters, loadTrigger: loadTrigger)
    }
    
    // MARK: - Private methods
    private func load(fromList list: PhotoItemsCollection? = nil, with params: FlickrInterestingRequest.Parameters, loadTrigger: Observable<Void> = Observable.empty()) -> Observable<PhotoItemsCollection> {
        return loadRequest(with: params).flatMap({ collection -> Observable<PhotoItemsCollection> in
            let newlist = list != nil ? list!.appending(contentsOf: collection) : collection
            let newparams = FlickrInterestingRequest.Parameters(itemsPerPage: params.itemsPerPage,
                                                           page: params.page + 1)
            let events = Observable.concat(
                Observable.just(newlist),
                Observable.never().takeUntil(loadTrigger),
                self.load(fromList: newlist, with: newparams, loadTrigger: loadTrigger)
            )
            return events
        })
    }
    private func loadRequest(with params: FlickrInterestingRequest.Parameters) -> Observable<PhotoItemsCollection> {
        let request = FlickrInterestingRequest(parameters: params)
        return request.rx_request().map { result -> PhotoItemsCollection in
            return PhotoItemsCollection(items: result?.photoItems, searchTerm: "popular")
        }
    }
}
