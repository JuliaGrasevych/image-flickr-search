//
//  MenuItem.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/23/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation
import RxDataSources

enum MenuItem: CustomStringConvertible {
    case search, popular
    
    var description: String {
        switch self {
        case .search: return "Search"
        case .popular: return "Popular"
        }
    }
}

extension MenuItem: IdentifiableType {
    var identity: MenuItem { return self }
}
