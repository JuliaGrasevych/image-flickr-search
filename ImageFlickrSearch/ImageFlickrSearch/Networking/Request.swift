//
//  Request.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/20/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation

enum HTTPMethod: String, RawRepresentable {
    case GET, POST, UPDATE
}

struct Request {
    let url: URL
    let method: HTTPMethod
    let parameters: [URLQueryItem]?
    let headers: [String: String]?
    let body: Data?
    
    var resultUrl: URL {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = parameters
        return urlComponents?.url ?? url
    }
    
    init(url: URL, method: HTTPMethod, parameters: [URLQueryItem]?, headers: [String: String]?, body: Data?) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.body = body
    }
    init(url: URL) {
        self.init(url: url, method: .GET, parameters: nil, headers: nil, body: nil)
    }
}
//
//private struct MutableRequest {
//    var request: Request
//}

protocol RequestGenerator {
    func request(with method: HTTPMethod) -> Request
    func withJsonSupport(request: Request) -> Request
    
    func generateRequest(method: HTTPMethod) -> Request
}

infix operator |>: AdditionPrecedence
func |> <T, U>(value: T, function: ((T) -> U)) -> U {
    return function(value)
}
