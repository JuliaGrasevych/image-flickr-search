//
//  FlickrManager.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/25/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import FlickrKit

class FlickrManager: NSObject {

    static let sharedInstance = FlickrManager()
    
    private let flickrKit = FlickrKit.shared()
    private let apiKey = "993278895770d9e09151d919c98cde33"
    private let sharedSecret = "3db9a747df6bfd8a"
    
    private override init() {
        super.init()
        flickrKit.initialize(withAPIKey: apiKey, sharedSecret: sharedSecret)
    }
    
    func search(_ searchText: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        let searchRequest = FKFlickrPhotosSearch()
        searchRequest.text = searchText
        flickrKit.call(searchRequest, completion: completion)
    }
}
