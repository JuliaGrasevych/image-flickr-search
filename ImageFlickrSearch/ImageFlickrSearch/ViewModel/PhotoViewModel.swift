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
    let title: Driver<String?>
    
    private let httpClient = FlickrHTTPClient()
    
    // MARK: - Initializers
    init(photo: PhotoItem) {
        self.photo = BehaviorRelay(value: photo)
        self.title = self.photo
            .map {
                photoDescription($0)
            }
            .asDriver(onErrorJustReturn: nil)
    }
    
    // MARK: - Public methods
    func imageDriver() -> Driver<UIImage?> {
        guard let url = photo.value.url else {
            return Driver.just(nil)
        }
        return httpClient.rx_image(url: url)
    }
}
// MARK: - Utility methods to call during init
private func photoDescription(_ photo: PhotoItem) -> String? {
    // format:
    // Title
    // by John Doe
    // on 01/01/1970
    let photoDate: String = {
        if let createDate = photo.createDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: createDate)
        }
        return "No date"
    }()
    return """
    \(photo.title ?? "No Title")
    by \(photo.ownerName ?? "No owner")
    on \(photoDate)
    """
}
