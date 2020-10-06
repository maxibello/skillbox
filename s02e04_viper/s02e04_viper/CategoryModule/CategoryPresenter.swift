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
    func loadCategories()
}

protocol CategoryPresenterOutput: AnyObject {
    func showLoader()
    func hideLoader()
    func didLoadCategories()
}

class CategoryPresenter: CategoryPresenterInput {
    var items: [Category] = []
    weak var outputDelegate: CategoryPresenterOutput?
    private let interactor: CategoryInteractorInput
    private let router: CategoryRouterInput
    
    init(interactor: CategoryInteractorInput, router: CategoryRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    func loadCategories() {
        outputDelegate?.showLoader()
        interactor.fetchCategories()
    }
}

extension CategoryPresenter: CategoryInteractorOutput {
    func categoriesReceiveError(message: String) {
        outputDelegate?.hideLoader()
    }
    
    func categoriesDidReceived(categories: [Category]) {
        items = categories
        outputDelegate?.didLoadCategories()
        outputDelegate?.hideLoader()
    }
}
