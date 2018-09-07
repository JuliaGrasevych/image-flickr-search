//
//  EmptyStateViewModel.swift
//  ImageFlickrSearch
//
//  Created by Julia on 9/7/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EmptyStateViewModel {
    let description: BehaviorRelay<String?> = BehaviorRelay(value: nil)
}
