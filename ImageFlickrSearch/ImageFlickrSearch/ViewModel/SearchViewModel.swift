//
//  CommonStateViewModel.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/24/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewModel {
    private struct DefaultKeys {
        static let searchQueueKey = "imageflickr.search.network.queue"
    }
    
    private let disposeBag = DisposeBag()
    private var itemsPerPage = 10
    
    func search(_ searchText: String, page: Int = 1, loadTrigger: Observable<Void> = Observable.empty()) -> Observable<PhotoItemsCollection> {
        let searchParameters = FlickrSearchRequest.Parameters(searchText: searchText,
                                                              itemsPerPage: self.itemsPerPage,
                                                              page: page)
        return search(fromList: nil, with: searchParameters, loadTrigger: loadTrigger)
    }
    
    // MARK: - Private methods
    private func search(fromList list: PhotoItemsCollection? = nil, with params: FlickrSearchRequest.Parameters, loadTrigger: Observable<Void> = Observable.empty()) -> Observable<PhotoItemsCollection> {
        return searchRequest(with: params).flatMap({ collection -> Observable<PhotoItemsCollection> in
            let newlist = list != nil ? list!.appending(contentsOf: collection) : collection
            let newparams = FlickrSearchRequest.Parameters(searchText: params.searchText,
                                                           itemsPerPage: params.itemsPerPage,
                                                           page: params.page + 1)
            let events = Observable.concat(
                Observable.just(newlist),
                Observable.never().takeUntil(loadTrigger),
                self.search(fromList: newlist, with: newparams, loadTrigger: loadTrigger)
            )
            return events
        })
    }
    private func searchRequest(with params: FlickrSearchRequest.Parameters) -> Observable<PhotoItemsCollection> {
        let request = FlickrSearchRequest(parameters: params)
        return request.rx_request().map { result -> PhotoItemsCollection in
            return PhotoItemsCollection(items: result?.photoItems, searchTerm: params.searchText)
        }
    }
}
