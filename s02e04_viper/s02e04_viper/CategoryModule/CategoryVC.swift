//
//  CategoryVC.swift
//  BlackStar
//
//  Created by Максим on 27.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class CategoryVC: UITableViewController {
    
    var presenter: CategoryPresenterInput!
    let configurator: CategoryConfiguratorProtocol = CategoryConfigurator()
    
    lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        loader.style = .large
        loader.color = .lightGray
        return loader
    }()
    
    override func viewDidLoad() {
        configurator.configure(with: self)
        
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        view.addSubview(loader)
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        guard presenter.items.count == 0 else { return }
        presenter.loadCategories()

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryViewCell
        cell.configure(with: presenter.items[indexPath.row])
        
        return cell
    }
}

extension CategoryVC: CategoryPresenterOutput {
    func showLoader() {
        loader.startAnimating()
    }
    
    func hideLoader() {
        loader.stopAnimating()
    }
    
    func didLoadCategories() {
        tableView.reloadData()
    }
}
