//
//  LoadingViewController.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 8/16/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import RxSwift

class LoadingViewController: UIViewController {
    @IBOutlet private var textLabel: UILabel!
    
    let viewModel = LoadingViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.text.asObservable()
            .bind(to: textLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}
