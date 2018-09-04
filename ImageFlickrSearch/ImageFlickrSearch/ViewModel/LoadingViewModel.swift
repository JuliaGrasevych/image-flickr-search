//
//  LoadingViewModel.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/16/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoadingViewModel {
    let text: BehaviorRelay<String?> = BehaviorRelay(value: nil)
}
