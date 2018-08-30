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

class PopularViewModel {
    let items: BehaviorRelay<[PhotoItem]?> = BehaviorRelay(value: nil)
    let state: Observable<CommonState>
    
    private let itemsObservable: Observable<[PhotoItem]?>
    
    init() {
        itemsObservable = items.asObservable().share(replay: 1)
        state = itemsObservable.flatMapLatest({ items -> Observable<CommonState> in
            guard let items = items else {
                // if no items check if there's a search in progress
                return Observable<CommonState>.create({ (observer: AnyObserver<CommonState>) -> Disposable in
                    guard false//let searchTerm = self.searchTerm.value //TODO: bind to status from network service
                        else {
                            observer.onNext(.empty)
                            return Disposables.create()
                    }
                    observer.onNext(.loading)
                    return Disposables.create()
                })
            }
            return Observable<CommonState>.just(.loaded)
        })
            .share(replay: 1)
    }
}
