//
//  CategoryVC.swift
//  BlackStar
//
//  Created by Максим on 27.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {
    
    @IBOutlet weak var rootView: RootView!
    
    override func viewDidLoad() {
        
        guard rootView.categories.count == 0 else { return }
        
        rootView.loader.startAnimating()
        BlackStarApiService.loadCategories() { [weak self] result in
            guard let self = self else { return }
            self.rootView.loader.stopAnimating()
            
            switch result {
            case .success(let categories):
                let sortedCategories = categories
                    .filter { $0.subcategories?.count ?? 0 > 0 }
                    .sorted(by: { Int($0.sortOrder) ?? Int.max < Int($1.sortOrder) ?? Int.max
                    })
                self.rootView.categories = sortedCategories
                self.rootView.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
