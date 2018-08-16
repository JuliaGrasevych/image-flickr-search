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
    
    let items: Variable<[PhotoItem]?> = Variable(nil)
    let searchTerm: Variable<String?> = Variable(nil)
    let state: Observable<CommonState>
    
    private let itemsObservable: Observable<[PhotoItem]?>
    private let searchTermObservable: Observable<String?>
    private let disposeBag = DisposeBag()
    
    init() {
        itemsObservable = items.asObservable()
            .distinctUntilChanged()
            .share(replay: 1)
        
        searchTermObservable = searchTerm.asObservable()
            .distinctUntilChanged()
            .debounce(1, scheduler: SerialDispatchQueueScheduler.init(internalSerialQueueName: "my.network.queue"))
            .share(replay: 1)
        state = Observable.combineLatest(itemsObservable, searchTermObservable, resultSelector: { (items, search) -> CommonState in
            guard let _ = items else {
                // if no items check if there's a search in progress
                return .empty
            }
            return .loaded
        })
            .share(replay: 1)
        
        // subscribe
        searchTermObservable.subscribe(onNext: { string in
            guard let string = string,
            !string.isEmpty else {
                self.items.value = nil
                return
            }
            self.search(string)
        })
            .disposed(by: disposeBag)
    }
    
    private func search(_ searchText: String) {
        FlickrSearchRequest(searchText: searchText).start { (result, error) in
            if let result = result {
                self.items.value = result
            }
        }
    }
}
