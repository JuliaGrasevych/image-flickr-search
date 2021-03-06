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
    
    let items: BehaviorRelay<PhotoItemsCollection?> = BehaviorRelay(value: nil)
    let searchTerm: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    let state: Driver<ContentState>
    
    var fullyLoaded: Bool {
        return currentCount == totalCount
    }
    var currentCount = 0
    
    private let itemsObservable: Observable<PhotoItemsCollection?>
    private let searchTermObservable: Observable<String?>
    private let disposeBag = DisposeBag()
    private var requestDisposeBag = DisposeBag()
    
    private var request: FlickrSearchRequest?
    private var pageNumber = 1
    private var pageCount = 0
    private var totalCount = 0
    private var itemsPerPage = 10
    
    // MARK: - Initializers
    init() {
        itemsObservable = items.asObservable()
            .distinctUntilChanged()
            .share()
        searchTermObservable = searchTerm.asObservable()
            .distinctUntilChanged()
            .debounce(1, scheduler: SerialDispatchQueueScheduler.init(internalSerialQueueName: DefaultKeys.searchQueueKey))
            .share()
        state = Observable.combineLatest(itemsObservable, searchTermObservable,
                                         resultSelector: { (items, search) -> ContentState in
                                            guard let items = items else {
                                                if let search = search, !search.isEmpty {
                                                    // if no items check if there's a search in progress
                                                    return .loading
                                                }
                                                return .default
                                            }
                                            if items.searchTerm != search {
                                                return .loading
                                            }
                                            if let count = items.count, count > 0 {
                                                return .loaded
                                            }
                                            return .empty
        })
            .distinctUntilChanged()
            .startWith(.default)
            .share()
            .asDriver(onErrorJustReturn: .default)
        
        // subscribe
        searchTermObservable.subscribe(onNext: { string in
            self.removePreviousResults()
            guard let string = string,
                !string.isEmpty else {
                    self.items.accept(nil)
                    return
            }
            self.search(string)
        })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Public methods
    func fetchResults() {
        guard let searchTerm = searchTerm.value else {
            return
        }
        pageNumber += 1
        search(searchTerm, page: pageNumber)
    }
    
    // MARK: - Private methods
    private func removePreviousResults() {
        pageNumber = 1
        pageCount = 0
        totalCount = 0
        currentCount = 0
    }
    private func search(_ searchText: String, page: Int = 1) {
        // don't cancel request when it's loading next pages
        if request?.isExecuting == true && page > 1 {
            return
        }
        // reinit dispose bar to clean it
        requestDisposeBag = DisposeBag()
        let searchParameters = FlickrSearchRequest.Parameters(searchText: searchText,
                                                              itemsPerPage: itemsPerPage,
                                                              page: page)
        request = FlickrSearchRequest(parameters: searchParameters)
        request?.rx_request()
            .subscribe(onNext: { result in
                let resultItems = PhotoItemsCollection(items: result?.photoItems, searchTerm: searchText)
                self.totalCount = result?.totalCount ?? 0
                self.pageNumber = result?.page ?? 1
                self.pageCount = result?.pages ?? 0
                self.currentCount += resultItems.count ?? 0
                if page > 1 {
                    let newArray = self.items.value?.appending(contentsOf: resultItems)
                    self.items.accept(newArray)
                } else {
                    self.items.accept(resultItems)
                }
            }, onError: { error in
                print(error)
            })
            .disposed(by: requestDisposeBag)
    }
}
