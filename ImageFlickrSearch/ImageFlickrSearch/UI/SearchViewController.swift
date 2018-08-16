//
//  SearchViewController.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/24/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewController: CommonViewController {
    
    @IBOutlet private var searchField: UISearchBar!
    
    let disposeBag = DisposeBag()
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.state
            .subscribe(onNext: { state in
                self.setupResults(state: state)
            })
            .disposed(by: disposeBag)
        
        searchField.rx.text
        .asDriver()
        .drive(viewModel.searchTerm)
        .disposed(by: disposeBag)
    }
}
