//
//  URLRequest+Request.swift
//  ImageFlickrSearch
//
//  Created by Julia on 8/28/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation

extension URLRequest {
    init(request: Request) {
        self.init(url: request.resultUrl)
        httpMethod = request.method.rawValue
        allHTTPHeaderFields = request.headers
        httpBody = request.body
    }
}
