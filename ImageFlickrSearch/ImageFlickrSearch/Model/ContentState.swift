//
//  CommonState.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/24/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation

enum ContentState {
    case `default`(message: String?)
    case loaded
    case loading
    case empty(message: String?)
}
