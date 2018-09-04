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
    
    var url: URL?
}
