//
//  CategoriesViewModel.swift
//  s02e04_mvvm
//
//  Created by Максим on 24.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CategoriesViewModel {
    
    private let _categories = BehaviorRelay<[Category]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    
    var categories: Driver<[Category]> {
        return _categories.asDriver()
    }
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var error: Driver<String?> {
        return _error.asDriver()
    }

    
    init() {
        loadCategories()
    }
    
    private func loadCategories() {
        _isFetching.accept(true)
        _error.accept(nil)
        
        BlackStarApiService.loadCategories() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                let sortedCategories = categories
                    .filter { $0.subcategories!.count > 0 }
                    .sorted(by: { Int($0.sortOrder) ?? Int.max < Int($1.sortOrder) ?? Int.max
                    })
                self._categories.accept(sortedCategories)
                self._isFetching.accept(false)
            case .failure(let error):
                print(error.localizedDescription)
                self._isFetching.accept(false)
                self._error.accept(error.localizedDescription)
            }
        }
    }
}
