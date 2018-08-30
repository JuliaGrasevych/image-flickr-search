//
//  FlickrSearchRequest.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/25/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit

class FlickrSearchRequest: FlickrRequestCommand {
    typealias Handler = ([PhotoItem]?, FlickrError?) -> Void
    
    struct Parameters {
        var searchText: String
        var itemsPerPage: Int
        var page: Int
    }
    
    let parameters: Parameters
    private var operation: Operation?
    
    init(parameters: Parameters) {
        self.parameters = parameters
    }
    
    func start(completion: @escaping Handler) {
        operation = FlickrManager.sharedInstance.search(parameters) { (result, error) in
            if let error = error {
                completion(nil, .flickrKit(error: error))
                return
            }
            guard let result = result?["photos"] as? [String: Any],
                let photos: Photos = Photos.fill(withDictionary: result),
                let photoArray = photos.photoItems else {
                    completion(nil, .invalidStructure)
                    return
            }
            photoArray.forEach({ $0.url = FlickrManager.sharedInstance.url(from: $0) })
            completion(photoArray, nil)
        }
    }
    func cancel() {
        operation?.cancel()
    }
}
