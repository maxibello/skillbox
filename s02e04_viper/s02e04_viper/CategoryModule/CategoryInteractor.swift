//
//  CategoryIteractor.swift
//  s02e04_viper
//
//  Created by Максим on 26.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Foundation

protocol CategoryInteractorInput {
    func fetchCategories()
}

protocol CategoryInteractorOutput {
    func categoriesDidReceived(categories: [Category])
    func categoriesReceiveError(message: String)
}

class CategoryInteractor: CategoryInteractorInput {
    
    var outputDelegate: CategoryInteractorOutput?
    
    func fetchCategories() {
        BlackStarApiService.loadCategories() { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let categories):
                        let sortedCategories = categories
                            .filter { $0.subcategories!.count > 0 }
                            .sorted(by: { Int($0.sortOrder) ?? Int.max < Int($1.sortOrder) ?? Int.max
                            })
                        self.outputDelegate?.categoriesDidReceived(categories: sortedCategories)
                    case .failure(let error):
                        self.outputDelegate?.categoriesReceiveError(message: error.localizedDescription)
                    }
                }
    }
    
    
}
