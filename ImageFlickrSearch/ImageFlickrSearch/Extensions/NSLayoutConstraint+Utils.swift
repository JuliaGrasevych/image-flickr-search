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
        guard let parentView = childView.superview else {
            print("Child view doesn't have superview")
            return
        }
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
        childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
    }
    static func centerInParent(childView: UIView) {
        guard let parentView = childView.superview else {
            print("Child view doesn't have superview")
            return
        }
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        childView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
    }
}
