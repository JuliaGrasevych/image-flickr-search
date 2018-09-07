//
//  FlickrSearchRequest.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/25/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit

class FlickrSearchRequest: FlickrRequestCommand {
    
    typealias Handler = (Photos?, FlickrError?) -> Void
    
    struct Parameters {
        var searchText: String
        var itemsPerPage: Int
        var page: Int
    }
    
    let parameters: Parameters
    var operation: Operation?
    
    // MARK: - Initializers
    init(parameters: Parameters) {
        self.parameters = parameters
    }
    
    // MARK: - Public methods
    func start(completion: @escaping Handler) {
        operation = FlickrManager.sharedInstance.search(parameters) { (result, error) in
            if let error = error {
                completion(nil, .flickrKit(error: error))
                return
            }
            guard let result = result,
                let photos: Photos = Photos.fill(withDictionary: result) else {
                    completion(nil, .invalidStructure)
                    return
            }
            photos.photoItems?.forEach {
                $0.thumbUrl = FlickrManager.sharedInstance.thumbUrl(from: $0)
                $0.url = FlickrManager.sharedInstance.url(from: $0)
            }
            completion(photos, nil)
        }
    }
}
