//
//  PhotoItem.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/24/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit

class Photos: Codable {
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case itemsPerPage = "perpage"
        case totalCount = "total"
        case photoItems = "photo"
    }
    var page: Int?
    var pages: Int?
    var itemsPerPage: Int?
    var totalCount: Int?
    var photoItems: [PhotoItem]?
}

class PhotoItem: NSObject, Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case owner
        case secret
        case server
        case farm
        case title
        case ispublic
        case isfriend
        case isfamily
        case createDate = "datetaken"
        case ownerName = "ownername"
    }
    
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    var ispublic: Int?
    var isfriend: Int?
    var isfamily: Int?
    var createDate: Date?
    var ownerName: String?
    
    var thumbUrl: URL?
    var url: URL?
}

// MARK: - DateDecodingStrategyProvider
extension Photos: DateDecodingStrategyProvider {
    static func dateDecodingStrategy() -> JSONDecoder.DateDecodingStrategy {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return .formatted(formatter)
    }
}
