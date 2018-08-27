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

extension URLRequest {
    init(request: Request) {
        self.init(url: request.resultUrl)
        httpMethod = request.method.rawValue
        allHTTPHeaderFields = request.headers
        httpBody = request.body
    }
}

enum Result<T, Error> {
    case success(T)
    case failure(Error)
}
struct Response {
    let statusCode: Int
    let body: Data?
}

extension URLSession {
    func synchronousDataTask(with urlRequest: URLRequest) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        let handler: (Data?, URLResponse?, Error?) -> Void = {
            print("""
                \(self.debugDescription) \(#function) -
                request \(urlRequest) =>
                received
                    response - \($1?.debugDescription ?? "nil"),
                    error - \($2?.localizedDescription ?? "nil")
                """)
            data = $0
            response = $1
            error = $2
            semaphore.signal()
        }
        print("""
            \(self.debugDescription) \(#function) -
            request \(urlRequest)
            """)
        self.dataTask(with: urlRequest, completionHandler: handler)
            .resume()
        _ = semaphore.wait()
        return (data, response, error)
    }
}

protocol HTTP {
    func execute(request: Request) -> Result<Response, Error>
}

class FlickrHTTPClient: HTTP {
    static let imageCache = NSCache<NSString, UIImage>()
    
    enum CustomError: Error {
        case defaultError
    }
    func execute(request: Request) -> Result<Response, Error> {
        let (data, response, error) = URLSession(configuration: .default).synchronousDataTask(with: URLRequest(request: request))
        if let error = error {
            return .failure(error)
        }
        guard let urlResponse = response as? HTTPURLResponse else {
            return .failure(CustomError.defaultError)
        }
        return .success(Response(statusCode: urlResponse.statusCode,
                                 body: data))
    }
    func get(url: URL) -> Result<Response, Error> {
        let request = Request(url: url)
        return execute(request: request)
    }
}

extension FlickrHTTPClient {
    private func handleRequest(result: Result<Response, Error>, observer: AnyObserver<Response>) -> Disposable {
        switch result {
        case let .success(response):
            observer.onNext(response)
            observer.onCompleted()
        case let .failure(error):
            observer.onError(error)
        }
        return Disposables.create()
    }
}

extension FlickrHTTPClient {
    func rx_image(url: URL) -> Driver<UIImage?> {
        return Observable.create({ [unowned self] observer -> Disposable in
            if let image = FlickrHTTPClient.imageCache.object(forKey: url.absoluteString as NSString) {
                observer.onNext(image)
                observer.onCompleted()
            } else {
                let result = self.get(url: url)
                switch result {
                case let .success(response):
                    var image: UIImage?
                    if let responseBody = response.body,
                        let responseImage = UIImage(data: responseBody) {
                        image = responseImage
                        FlickrHTTPClient.imageCache.setObject(responseImage, forKey: url.absoluteString as NSString)
                    }
                    observer.onNext(image)
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        })
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .asDriver(onErrorJustReturn: nil)
        
    }
}
