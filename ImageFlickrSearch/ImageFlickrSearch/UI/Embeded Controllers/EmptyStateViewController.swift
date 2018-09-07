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
    let viewModel = EmptyStateViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet private var textLabel: UILabel!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.description.asObservable()
            .bind(to: textLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
