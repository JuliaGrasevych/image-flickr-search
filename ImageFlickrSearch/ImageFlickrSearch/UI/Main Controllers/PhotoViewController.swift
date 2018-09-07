//
//  PhotoViewController.swift
//  ImageFlickrSearch
//
//  Created by Julia on 9/7/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoViewController: UIViewController {
    @IBOutlet private var photoView: ImageInfoView!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var navigationBar: UINavigationBar!
    @IBOutlet private var doneButton: UIBarButtonItem!
    
    let viewModel: PhotoViewModel
    let disposeBag = DisposeBag()
    
    init(photo: PhotoItem) {
        viewModel = PhotoViewModel(photo: photo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = doneButton
        navigationBar.items?.append(navigationItem)
        
        photoView.update(state: .loading)
        viewModel.imageDriver()
            .drive(onNext: { self.photoView.update(state: .loaded($0)) })
            .disposed(by: disposeBag)
        
        doneButton.rx
            .tap
            .bind { self.dismiss(animated: true, completion: nil) }
            .disposed(by: disposeBag)
    }
}
