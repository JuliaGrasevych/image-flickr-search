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

    private struct DefaultKeys {
        static let photosKey = "photos"
    }
    
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
        return flickrKit.call(searchRequest) { (result, error) in
            let normalResult = self.normalizeResponse(result?[DefaultKeys.photosKey] as? [String: Any],
                                                      for: [Photos.CodingKeys.totalCount.stringValue])
            completion(normalResult, error)
        }
    }
    func getInteresting(_ parameters: FlickrInterestingRequest.Parameters, completion: @escaping ([String: Any]?, Error?) -> Void) -> Operation {
        let popularRequest = FKFlickrInterestingnessGetList()
        popularRequest.per_page = "\(parameters.itemsPerPage)"
        popularRequest.page = "\(parameters.page)"
        return flickrKit.call(popularRequest) { (result, error) in
            let normalResult = self.normalizeResponse(result?[DefaultKeys.photosKey] as? [String: Any],
                                                      for: [Photos.CodingKeys.totalCount.stringValue])
            completion(normalResult, error)
        }
    }
    func url(from photoItem: PhotoItem) -> URL? {
        guard let photoDictionary = photoItem.jsonDictionary else {
            return nil
        }
        return flickrKit.photoURL(for: .medium800, fromPhotoDictionary: photoDictionary)
    }
    
    private func normalizeResponse(_ response: [String: Any]?, for keys: [String]) -> [String: Any]? {
        // for some requests "total" is String, for others - Int
        // normalize it to be Int
        guard var response = response else {
            return nil
        }
        keys.forEach {
            if let stringValue = response[$0] as? String {
                response[$0] = Int(stringValue)
            }
        }
        return response
    }
}
