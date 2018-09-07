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
    
    private static let imageCache = GenericCache<UIImage>()
    private let session = URLSession(configuration: .default)
    private var imageCache: GenericCache<UIImage> {
        return type(of: self).imageCache
    }
    // MARK: - Public methods
    func execute(request: Request) -> Observable<Data> {
        return session.rx
            .data(request: URLRequest(request: request))
    }
    func get(url: URL) -> Observable<Data> {
        let request = Request(url: url)
        return execute(request: request)
    }
}

extension FlickrHTTPClient {
    func rx_image(url: URL) -> Driver<UIImage?> {
        let sequence: Observable<UIImage?> = {
            if let image = self.imageCache[url.absoluteString] {
                return Observable.just(image)
            } else {
                return self.get(url: url).map({ result -> UIImage? in
                    var image: UIImage?
                    if let responseImage = UIImage(data: result) {
                        image = responseImage
                        self.imageCache[url.absoluteString] = responseImage
                    }
                    return image
                })
            }
        }()
        return sequence
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .asDriver(onErrorJustReturn: nil)
    }
}
