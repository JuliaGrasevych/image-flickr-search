//
//  ImageInfoView.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/27/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit

class ImageInfoView: UIView {
    private var imageView: UIImageView!
    private var infoLabel: UILabel!
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    var infoMessage: String? {
        didSet {
            infoLabel.text = infoMessage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultInit()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        defaultInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultInit()
    }
    
    private func defaultInit() {
        imageView = UIImageView(frame: self.bounds)
        addSubview(imageView)
        NSLayoutConstraint.scaleToFillParent(childView: imageView)
        infoLabel = UILabel(frame: self.bounds)
        addSubview(infoLabel)
        NSLayoutConstraint.scaleToFillParent(childView: infoLabel)
    }
}

extension ImageInfoView {
    enum ImageInfoState {
        case empty
        case loading(String)
        case error(String)
        case loaded(UIImage?)
    }
    func update(state: ImageInfoState) {
        switch state {
        case .empty:
            image = nil
            infoMessage = nil
        case let .loading(message), let .error(message):
            image = nil
            infoMessage = message
        case let .loaded(image):
            self.image = image
            infoMessage = nil
        }
    }
}
