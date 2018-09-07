//
//  ImageInfoView.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/27/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit

class ImageInfoView: UIView {
    var image: UIImage? {
        didSet {
            imageView.image = image
            imageView.isHidden = (image == nil)
        }
    }
    var infoMessage: String? {
        didSet {
            infoLabel.text = infoMessage
            infoLabel.isHidden = (infoMessage == nil)
        }
    }
    override var intrinsicContentSize: CGSize {
        guard let image = imageView.image else {
            return super.intrinsicContentSize
        }
        let imageViewWidth = imageView.frame.width
        let imageViewHeight = imageViewWidth / image.aspectRatio
        return CGSize(width: imageViewWidth, height: imageViewHeight)
    }
    
    private var imageView: UIImageView!
    private var infoLabel: UILabel!
    private var loader: UIActivityIndicatorView!
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultInit()
    }
    // MARK: - Private setup methods
    private func defaultInit() {
        setupImageView()
        setupInfoLabel()
        setupLoader()
    }
    private func setupImageView() {
        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        addSubview(imageView)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        NSLayoutConstraint.scaleToFillParent(childView: imageView)
    }
    private func setupInfoLabel() {
        infoLabel = UILabel(frame: self.bounds)
        addSubview(infoLabel)
        NSLayoutConstraint.scaleToFillParent(childView: infoLabel)
    }
    private func setupLoader() {
        loader = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loader.hidesWhenStopped = true
        loader.stopAnimating()
        addSubview(loader)
        NSLayoutConstraint.centerInParent(childView: loader)
    }
}

extension ImageInfoView {
    enum ImageInfoState {
        case empty
        case loading
        case error(String)
        case loaded(UIImage?)
    }
    func update(state: ImageInfoState) {
        image = nil
        infoMessage = nil
        switch state {
        case .empty:
            loader.startAnimating()
        case .loading:
            loader.startAnimating()
        case let .error(message):
            loader.stopAnimating()
            infoMessage = message
        case let .loaded(image):
            self.image = image
            loader.stopAnimating()
        }
        invalidateIntrinsicContentSize()
    }
}
