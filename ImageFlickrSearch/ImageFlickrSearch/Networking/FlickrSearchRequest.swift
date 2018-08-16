//
//  FlickrSearchRequest.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/25/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit

class FlickrSearchRequest {
    let searchText: String
    
    init(searchText: String) {
        self.searchText = searchText
    }
    
    func start(completion: @escaping ([PhotoItem]?, Error?) -> Void) {
        FlickrManager.sharedInstance.search(searchText) { (result, error) in
            guard let photos = result?["photos"] as? [String: Any],
            let photoArray = photos["photo"] as? [[String: Any]] else {
                completion(nil, error)
                return
            }
            
            let items = photoArray.compactMap({ photo -> PhotoItem? in
                return PhotoItem.fill(withDictionary: photo)
            })
            completion(items, error)
        }
    }
}
