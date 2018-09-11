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
    let items: BehaviorRelay<PhotoItemsCollection?> = BehaviorRelay(value: nil)
    let state: Driver<ContentState>
    
    var fullyLoaded: Bool {
        return currentCount == totalCount
    }
    var currentCount = 0
    
    private let itemsObservable: Observable<PhotoItemsCollection?>
    private let disposeBag = DisposeBag()
    
    private var request: FlickrInterestingRequest?
    private var pageNumber = 1
    private var pageCount = 0
    private var totalCount = 0
    private var itemsPerPage = 10
    
    // MARK: - Initializers
    init() {
        itemsObservable = items.asObservable()
            .distinctUntilChanged()
            .share()
        state = itemsObservable.map { photos -> ContentState in
            guard let photos = photos else {
                return .loading
            }
            if let count = photos.count, count > 0 {
                return .loaded
            }
            return .empty
            }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: .default)
        
        downloadInteresting()
    }
    
    // MARK: - Public methods
    func moreResults() {
        pageNumber += 1
        downloadInteresting(page: pageNumber)
    }
    
    // MARK: - Private methods
    private func downloadInteresting(page: Int = 1) {
        // don't cancel request when it's loading next pages
        if request?.isExecuting == true && page > 1 {
            return
        }
        let parameters = FlickrInterestingRequest.Parameters(itemsPerPage: itemsPerPage,
                                                             page: page)
        request = FlickrInterestingRequest(parameters: parameters)
        request?.rx_request()
            .subscribe(onNext: { result in
                let resultItems = PhotoItemsCollection(items: result?.photoItems, searchTerm: "popular")
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
            .disposed(by: disposeBag)
    }
}
