//
//  NSLayoutConstraint+Utils.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/27/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

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
    static func centerInParent(childView: UIView) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        let xConstraint = NSLayoutConstraint(item: childView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: childView.superview,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0)
        let yConstraint = NSLayoutConstraint(item: childView,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: childView.superview,
                                              attribute: .centerY,
                                              multiplier: 1,
                                              constant: 0)
        NSLayoutConstraint.activate([xConstraint, yConstraint])
    }
}
