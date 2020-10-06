//
//  CategoryVC.swift
//  BlackStar
//
//  Created by Максим on 27.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryVC: UIViewController {
    
    let viewModel = CategoriesViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        loader.style = .large
        loader.color = .lightGray
        return loader
    }()
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        view.addSubview(loader)
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        bindObservables()
    }
    
    private func bindObservables() {
        viewModel
            .categories
            .drive(tableView.rx.items(cellIdentifier: CategoryViewCell.identifier,
                                      cellType: CategoryViewCell.self))                           {
                _, category, cell in
                cell.configure(with: category)
        }.disposed(by: disposeBag)
        
        viewModel
            .isFetching
            .drive(loader.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
