//
//  EmptyStateViewController.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/24/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EmptyStateViewController: UIViewController {
    @IBOutlet private var textLabel: UILabel!
    
    let viewModel = EmptyStateViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.description.asObservable()
            .bind(to: textLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
