//
//  LoadingViewModel.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/16/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation
import RxSwift

class LoadingViewModel {
    let text: Variable<String?> = Variable(nil)
    let textObservable: Observable<String?>
    
    init() {
        textObservable = text.asObservable()
            .map({ value -> String? in
                if let value = value {
                    return "Search for \"\(value)\""
                } else {
                    return nil
                }
            })
        .share()
    }
}
