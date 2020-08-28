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
    
    override func viewDidLoad() {
        BlackStarApiService.loadCategories() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                let sortedCategories = categories.sorted(by: {
                    left, right in
                    return Int(left.sortOrder) ?? Int.max < Int(right.sortOrder) ?? Int.max
                })
                self.categories = sortedCategories
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCategory = categories[indexPath.row]
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Subcategories",
            let subcategoryVC = segue.destination as? SubcategoryVC,
        let selectedCategory = selectedCategory {
            subcategoryVC.subcategories = selectedCategory.subcategories.sorted(by: {
                left, right in
                return Int(left.sortOrder) ?? Int.max < Int(right.sortOrder) ?? Int.max
            })
        }
    }
}
