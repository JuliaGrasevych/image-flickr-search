//
//  PhotoItemsCollection.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/16/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation
import RxSwift

class PhotoItemsCollection {
    var searchTerm: String
    var count: Int? {
        return items?.count
    }
    private(set) var items: [PhotoItem]?
    private var currentPosition = 0
    
    init(items: [PhotoItem]?, searchTerm: String) {
        self.items = items
        self.searchTerm = searchTerm
    }
    
    func append(contentsOf collection: PhotoItemsCollection?) {
        guard let collectionItems = collection?.items else {
            return
        }
        self.items?.append(contentsOf: collectionItems)
    }
}

extension PhotoItemsCollection: Sequence, IteratorProtocol {
    typealias Element = PhotoItem
    
    func makeIterator() -> PhotoItemsCollection {
        currentPosition = 0
        return self
    }
    func next() -> PhotoItem? {
        guard let items = items,
        currentPosition < items.count else {
            return nil
        }
        let item = items[currentPosition]
        currentPosition += 1
        return item
    }
}

extension PhotoItemsCollection: Equatable {
    static func == (lhs: PhotoItemsCollection, rhs: PhotoItemsCollection) -> Bool {
        if lhs === rhs {
            return true
        }
        if lhs.items == rhs.items,
            lhs.searchTerm == rhs.searchTerm {
                return true
        }
        return false
    }
}
