//
//  PhotoViewModel.swift
//  ImageFlickrSearch
//
//  Created by Julia on 9/7/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PhotoViewModel {
    let photo: BehaviorRelay<PhotoItem>
    private let httpClient = FlickrHTTPClient()
    
    init(photo: PhotoItem) {
        self.photo = BehaviorRelay(value: photo)
    }
    
    func imageDriver() -> Driver<UIImage?> {
        guard let url = photo.value.url else {
            return Driver.just(nil)
        }
        return httpClient.rx_image(url: url)
    }
}
