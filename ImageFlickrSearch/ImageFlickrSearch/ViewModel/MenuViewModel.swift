//
//  MenuViewModel.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/23/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class MenuViewModel {
    var items: Observable<[SectionModel<Int, MenuItem>]> {
        return Observable.just([.search, .popular]).map { items in
            return [SectionModel(model: 0, items: items)]
        }
    }
}
