//
//  UIImage+AspectRatio.swift
//  ImageFlickrSearch
//
//  Created by Julia on 9/7/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit

extension UIImage {
    var aspectRatio: CGFloat {
        return size.width / size.height
    }
}
