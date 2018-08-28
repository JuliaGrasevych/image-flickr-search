//
//  UICollectionView+RegisterCells.swift
//  ImageFlickrSearch
//
//  Created by Julia on 8/28/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(class: T.Type, reuseIdentifier: String? = nil) {
        register(T.self, forCellWithReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }
    
    func registerNib<T: UICollectionViewCell>(class: T.Type, reuseIdentifier: String? = nil) {
        register(UINib(nibName: String(describing: T.self), bundle: nil),
                 forCellWithReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }
    
    func dequeue<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self),
                                           for: indexPath) as? T else {
                                            fatalError("Could not deque cell with type \(T.self)")
                                            
        }
        return cell
    }
}
