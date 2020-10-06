//
//  CategoryConfigurator.swift
//  s02e04_viper
//
//  Created by Максим on 03.10.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Foundation

protocol CategoryConfiguratorProtocol: class {
    func configure(with viewController: CategoryVC)
}

class CategoryConfigurator: CategoryConfiguratorProtocol {
    func configure(with viewController: CategoryVC) {

        let router = CategoryRouter(viewController: viewController)
        let interactor = CategoryInteractor()
        let presenter = CategoryPresenter(interactor: interactor, router: router)
        
        viewController.presenter = presenter
        presenter.outputDelegate = viewController
        interactor.outputDelegate = presenter
    }
}
