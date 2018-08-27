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

    let searchText: String
    
    init(searchText: String) {
        self.searchText = searchText
    }
    
    func start(completion: @escaping Handler) {
        FlickrManager.sharedInstance.search(searchText) { (result, error) in
            if let error = error {
                completion(nil, .flickrKit(error: error))
                return
            }
            guard let photos = result?["photos"] as? [String: Any],
                let photoArray = photos["photo"] as? [[String: Any]] else {
                    completion(nil, .invalidStructure)
                    return
            }
            let items = photoArray.compactMap({ photo -> PhotoItem? in
                let item: PhotoItem? = PhotoItem.fill(withDictionary: photo)
                if let item = item {
                    item.url = FlickrManager.sharedInstance.url(from: item)
                }
                return item
            })
            completion(items, nil)
        }
    }
}
