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
    
    lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        loader.style = .large
        loader.color = .lightGray
        return loader
    }()
    
    override func viewDidLoad() {
        configure()
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
    
    private func configure() {
        presenter = CategoryPresenter()
        presenter.outputDelegate = self
        
        let interactor = CategoryIteractor()
        interactor.outputDelegate = presenter as? CategoryPresenter
        
        presenter.interactor = interactor
    }
}

extension CategoryVC: CategoryPresenterOutput {
    func showLoader() {
        loader.startAnimating()
    }
    
    func hideLoader() {
        loader.stopAnimating()
    }
    
    func didLoadCategoriesError(message: String) {
        showError(message: message)
    }
    
    func didLoadCategories() {
        tableView.reloadData()
    }
}
