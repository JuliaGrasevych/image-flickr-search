//
//  MasterViewController.swift
//  ImageFlickrSearch
//
//  Created by Iuliia.Grasevych on 7/23/18.
//  Copyright © 2018 JuliaG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol MenuItemControllerDelegate: class {
    func didSelect(_ item: MenuItem)
}

class MasterViewController: UITableViewController {

    weak var delegate: MenuItemControllerDelegate?
    let disposeBag = DisposeBag()
    let viewModel = MenuViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        viewModel.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        tableView.rx
            .modelSelected(MenuItem.self)
            .subscribe(onNext: { self.delegate?.didSelect($0) })
            .disposed(by: disposeBag)
    }

    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<Int, MenuItem>> {
        return RxTableViewSectionedReloadDataSource<SectionModel<Int, MenuItem>>(
            configureCell: { (_, table, idxPath, item) in
                let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: idxPath)
                cell.textLabel?.text = item.description
                return cell
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
}
