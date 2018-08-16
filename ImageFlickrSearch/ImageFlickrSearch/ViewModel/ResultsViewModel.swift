//
//  ResultsViewModel.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/16/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class ResultsViewModel {
    
    var items: Observable<[SectionModel<Int, PhotoItem>]> {
        return resultItems.asObservable()
            .filter({ $0 != nil })
            .map { items in
            return [SectionModel(model: 0, items: items!)]
        }
    }
    
    let resultItems: Variable<[PhotoItem]?> = Variable(nil)
}
