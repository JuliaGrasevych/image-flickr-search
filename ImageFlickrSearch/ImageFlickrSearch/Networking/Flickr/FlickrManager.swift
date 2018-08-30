//
//  FlickrManager.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/25/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import FlickrKit

enum FlickrError: Error {
    case flickrKit(error: Error)
    case invalidStructure
    case decodingFailed
}

class FlickrManager: NSObject {

    static let sharedInstance = FlickrManager()
    
    private let flickrKit = FlickrKit.shared()
    private let apiKey = "993278895770d9e09151d919c98cde33"
    private let sharedSecret = "3db9a747df6bfd8a"
    
    private override init() {
        super.init()
        flickrKit.initialize(withAPIKey: apiKey, sharedSecret: sharedSecret)
    }
    
    func search(_ searchParameters: FlickrSearchRequest.Parameters, completion: @escaping ([String: Any]?, Error?) -> Void) -> Operation {
        let searchRequest = FKFlickrPhotosSearch()
        searchRequest.text = searchParameters.searchText
        searchRequest.per_page = "\(searchParameters.itemsPerPage)"
        searchRequest.page = "\(searchParameters.page)"
        return flickrKit.call(searchRequest, completion: completion)
    }
    func url(from photoItem: PhotoItem) -> URL? {
        guard let photoDictionary = photoItem.jsonDictionary else {
            return nil
        }
        return flickrKit.photoURL(for: .thumbnail100, fromPhotoDictionary: photoDictionary)
    }
}
