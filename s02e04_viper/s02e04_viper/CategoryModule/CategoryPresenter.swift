//
//  CategoryPresenter.swift
//  s02e04_viper
//
//  Created by Максим on 26.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Foundation

protocol CategoryPresenterInput {
    var items: [Category] { get set }
    var outputDelegate: CategoryPresenterOutput? { get set }
    var interactor: CategoryIteractorInput? { get set }
    func loadCategories()
}

protocol CategoryPresenterOutput: AnyObject {
    func showLoader()
    func hideLoader()
    func didLoadCategories()
    func didLoadCategoriesError(message: String)
}

class CategoryPresenter: CategoryPresenterInput {
    var interactor: CategoryIteractorInput?
    var items: [Category] = []
    weak var outputDelegate: CategoryPresenterOutput?
    
    func loadCategories() {
        outputDelegate?.showLoader()
        interactor?.fetchCategories()
    }
}

extension CategoryPresenter: CategoryIteractorOutput {
    func categoriesReceiveError(message: String) {
        outputDelegate?.didLoadCategoriesError(message: message)
        outputDelegate?.hideLoader()
    }
    
    func categoriesDidReceived(categories: [Category]) {
        items = categories
        outputDelegate?.didLoadCategories()
        outputDelegate?.hideLoader()
    }
}
