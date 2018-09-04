//
//  UIImage+Utils.swift
//  ImageFlickrSearch
//
//  Created by Julia on 8/30/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit

enum ImageContentOrientation {
    case horizontal, verical, square
}

extension UIImage {
    var contentOrientation: ImageContentOrientation {
        let width = size.width
        let height = size.height
        if width == height {
            return .square
        }
        if width < height {
            return .verical
        }
        return .horizontal
    }
}
