//
//  GenericCache.swift
//  ImageFlickrSearch
//
//  Created by Julia on 8/28/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation

class GenericCache<T: AnyObject> {
    
    private let cache: NSCache<NSString, T>
    
    init() {
        cache = NSCache<NSString, T>()
    }
    
    subscript(key: String) -> T? {
        get {
            return cache.object(forKey: key as NSString)
        }
        set {
            guard let newValue = newValue else {
                cache.removeObject(forKey: key as NSString)
                return
            }
            cache.setObject(newValue, forKey: key as NSString)
        }
    }
}
