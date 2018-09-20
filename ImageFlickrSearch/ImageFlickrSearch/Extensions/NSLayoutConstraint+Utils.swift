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
        childView.anchor(to: parentView, at: \UIView.topAnchor)
        childView.anchor(to: parentView, at: \UIView.bottomAnchor)
        childView.anchor(to: parentView, at: \UIView.leadingAnchor)
        childView.anchor(to: parentView, at: \UIView.trailingAnchor)
    }
    static func centerInParent(childView: UIView) {
        guard let parentView = childView.superview else {
            print("Child view doesn't have superview")
            return
        }
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.anchor(to: parentView, at: \UIView.centerXAnchor)
        childView.anchor(to: parentView, at: \UIView.centerYAnchor)
    }
}

extension UIView {
    func anchor<Anchor, AnchorType>(to view: UIView, at anchor: KeyPath<UIView, Anchor>) where Anchor: NSLayoutAnchor<AnchorType> {
        self[keyPath: anchor].constraint(equalTo: view[keyPath: anchor]).isActive = true
    }
}
