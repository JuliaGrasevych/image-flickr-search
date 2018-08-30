//
//  URLSession+SynchronousTask.swift
//  ImageFlickrSearch
//
//  Created by Julia on 8/28/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation

struct DataTaskResponse {
    let data: Data?
    let response: URLResponse?
    let error: Error?
}

extension URLSession {
    func synchronousDataTask(with urlRequest: URLRequest) -> DataTaskResponse? {
        var response: DataTaskResponse?
        
        let semaphore = DispatchSemaphore(value: 0)
        let handler: (Data?, URLResponse?, Error?) -> Void = {
            print("""
                \(self.debugDescription) \(#function) -
                request \(urlRequest) =>
                received
                response - \($1?.debugDescription ?? "nil"),
                error - \($2?.localizedDescription ?? "nil")
                """)
            response = DataTaskResponse(data: $0,
                                        response: $1,
                                        error: $2)
            semaphore.signal()
        }
//        print("""
//            \(self.debugDescription) \(#function) -
//            request \(urlRequest)
//            """)
        self.dataTask(with: urlRequest, completionHandler: handler)
            .resume()
        _ = semaphore.wait()
        return response
    }
}
