//
//  ToDoListConfigurator.swift
//  s02e04_viper
//
//  Created by Максим on 03.10.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Foundation


protocol TDLConfiguratorProtocol: class {
    func configure(with viewController: ToDoListViewController)
}

class TDLConfigurator: TDLConfiguratorProtocol {
    func configure(with viewController: ToDoListViewController) {

        let router = ToDoListRouter(viewController: viewController)
        let interactor = ToDoListInteractor()
        let presenter = ToDoListPresenter(interactor: interactor, router: router)
        
        viewController.presenter = presenter
        presenter.outputDelegate = viewController
        interactor.outputDelegate = presenter
    }
}
