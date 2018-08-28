//
//  FlickrHTTPClient.swift
//  ImageFlickrSearch
//
//  Created by Julia on 8/28/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FlickrHTTPClient: HTTP {
    
    enum CustomError: Error {
        case defaultError
    }
    
    private static let imageCache = GenericCache<UIImage>()
    private var imageCache: GenericCache<UIImage> {
        return type(of: self).imageCache
    }
    
    func execute(request: Request) -> Result<Response, Error> {
        let session = URLSession(configuration: .default)
        guard let response = session.synchronousDataTask(with: URLRequest(request: request)) else {
            return .failure(CustomError.defaultError)
        }
        if let error = response.error {
            return .failure(error)
        }
        guard let urlResponse = response.response as? HTTPURLResponse else {
            return .failure(CustomError.defaultError)
        }
        return .success(Response(statusCode: urlResponse.statusCode,
                                 body: response.data))
    }
    func get(url: URL) -> Result<Response, Error> {
        let request = Request(url: url)
        return execute(request: request)
    }
}

extension FlickrHTTPClient {
    func rx_image(url: URL) -> Driver<UIImage?> {
        return Observable.create({ [unowned self] observer -> Disposable in
            if let image = self.imageCache[url.absoluteString] {
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
                        self.imageCache[url.absoluteString] = responseImage
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
