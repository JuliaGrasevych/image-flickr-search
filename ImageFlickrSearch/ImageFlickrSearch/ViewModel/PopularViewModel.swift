//
//  PopularViewModel.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/25/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import RxSwift

class PopularViewModel {
    let items: Variable<[PhotoItem]?> = Variable(nil)
    let state: Observable<CommonState>
    
    private let itemsObservable: Observable<[PhotoItem]?>
    
    init() {
        itemsObservable = items.asObservable().share(replay: 1)
        state = itemsObservable.flatMapLatest({ items -> Observable<CommonState> in
            guard let items = items else {
                // if no items check if there's a search in progress
                return Observable<CommonState>.create({ (o: AnyObserver<CommonState>) -> Disposable in
                    guard false//let searchTerm = self.searchTerm.value //TODO: bind to status from network service
                        else {
                            o.onNext(.empty)
                            return Disposables.create()
                    }
                    o.onNext(.loading)
                    return Disposables.create()
                })
            }
            return Observable<CommonState>.just(.loaded)
        })
            .share(replay: 1)
    }
}
