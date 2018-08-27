//
//  NSLayoutConstraint+Utils.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/27/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    static func scaleToFillParent(childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[child]|",
                                                               options: .alignAllLeading,
                                                               metrics: nil,
                                                               views: ["child": childView])
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[child]|",
                                                               options: .alignAllLeading,
                                                               metrics: nil,
                                                               views: ["child": childView])
        NSLayoutConstraint.activate(hConstraints + vConstraints)
    }
}
