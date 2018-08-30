//
//  CommonStateViewModel.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/24/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewModel {
    
    let items: Variable<PhotoItemsCollection?> = Variable(nil)
    let searchTerm: Variable<String?> = Variable(nil)
    let state: Observable<CommonState>
    
    var currentCount = 0
    
    private let itemsObservable: Observable<PhotoItemsCollection?>
    private let searchTermObservable: Observable<String?>
    private let disposeBag = DisposeBag()
    
    private var request: FlickrSearchRequest?
    private var pageNumber = 0
    private var pageCount = 0
    private var totalCount = 0
    private var itemsPerPage = 10
    
    init() {
        itemsObservable = items.asObservable()
            .distinctUntilChanged()
            .share()
        
        searchTermObservable = searchTerm.asObservable()
            .distinctUntilChanged()
            .debounce(1, scheduler: SerialDispatchQueueScheduler.init(internalSerialQueueName: "my.network.queue"))
            .share()
        state = Observable.combineLatest(itemsObservable, searchTermObservable,
                                         resultSelector: { (items, search) -> CommonState in
                                            guard let items = items else {
                                                if let search = search, !search.isEmpty {
                                                    // if no items check if there's a search in progress
                                                    return .loading
                                                }
                                                return .empty
                                            }
                                            if items.searchTerm != search {
                                                return .loading
                                            }
                                            return .loaded
        })
            .observeOn(MainScheduler.instance)
        
        // subscribe
        searchTermObservable.subscribe(onNext: { string in
            self.pageNumber = 0
            guard let string = string,
            !string.isEmpty else {
                self.items.value = nil
                return
            }
            self.search(string)
        })
            .disposed(by: disposeBag)
    }
    
    func fetchResults() {
        guard let searchTerm = searchTerm.value else {
            return
        }
        pageNumber += 1
        search(searchTerm, page: pageNumber)
    }
    
    private func search(_ searchText: String, page: Int = 0) {
        request?.cancel()
        let searchParameters = FlickrSearchRequest.Parameters(searchText: searchText,
                                                              itemsPerPage: itemsPerPage,
                                                              page: page)
        request = FlickrSearchRequest(parameters: searchParameters)
        request?.start { (result, error) in
            let resultItems: PhotoItemsCollection? = {
                return PhotoItemsCollection(items: result, searchTerm: searchText)
            }()
            if page > 0 {
                self.items.value?.append(contentsOf: resultItems)
            } else {
                self.items.value = resultItems
            }
        }
    }
}
