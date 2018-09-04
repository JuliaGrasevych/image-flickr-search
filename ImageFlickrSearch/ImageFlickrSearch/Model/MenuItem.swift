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
    case search, interesting
    
    var description: String {
        switch self {
        case .search: return "Search"
        case .interesting: return "Interesting"
        }
    }
}

extension MenuItem: IdentifiableType {
    var identity: MenuItem { return self }
}
