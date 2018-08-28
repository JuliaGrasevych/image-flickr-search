//
//  HTTP.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/20/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum Result<T, Error> {
    case success(T)
    case failure(Error)
}
struct Response {
    let statusCode: Int
    let body: Data?
}

protocol HTTP {
    func execute(request: Request) -> Result<Response, Error>
}
