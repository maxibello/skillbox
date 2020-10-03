//
//  CategoryRouter.swift
//  s02e04_viper
//
//  Created by Максим on 03.10.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

protocol CategoryRouterInput {
    func showError(message: String)
}

protocol CategoryRouterOuput {}

class CategoryRouter: CategoryRouterInput {
    weak var viewController: CategoryVC!
    
    init(viewController: CategoryVC) {
        self.viewController = viewController
    }
    
    func showError(message: String) {
        viewController.showError(message: message)
    }
}
