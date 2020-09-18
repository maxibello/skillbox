//
//  CategoryVC.swift
//  BlackStar
//
//  Created by Максим on 27.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class CategoryVC: UITableViewController {
    
    var categories: [Category] = []
    var selectedCategory: Category?
    
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
        
        guard categories.count == 0 else { return }
        
        loader.startAnimating()
        BlackStarApiService.loadCategories() { [weak self] result in
            guard let self = self else { return }
            self.loader.stopAnimating()
            
            switch result {
            case .success(let categories):
                let sortedCategories = categories
                    .filter { $0.subcategories!.count > 0 }
                    .sorted(by: { Int($0.sortOrder) ?? Int.max < Int($1.sortOrder) ?? Int.max
                    })
                self.categories = sortedCategories
                print(self.categories)
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryViewCell
        cell.configure(with: categories[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCategory = categories[indexPath.row]
        return indexPath
    }
}
