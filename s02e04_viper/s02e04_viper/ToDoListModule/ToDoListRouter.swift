//
//  ToDoListRouter.swift
//  s02e04_viper
//
//  Created by Максим on 03.10.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

protocol ToDoListRouterInput {
    func showNewItemDialog(presenter: ToDoListPresenterInput)
    func showError(message: String)
}

protocol ToDoListRouterOuput {}

class ToDoListRouter: ToDoListRouterInput {
    weak var viewController: ToDoListViewController!
    
    init(viewController: ToDoListViewController) {
        self.viewController = viewController
    }
    
    func showNewItemDialog(presenter: ToDoListPresenterInput) {
        let alert = UIAlertController(title: "New task", message: "Type what you want to do", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: { [weak alert] action in
            guard let textField = alert?.textFields?.first else {
                return
            }
            if let text = textField.text, text.count > 0 {
                presenter.addItem(with: text)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.viewController.present(alert, animated: true, completion: nil)
    }
    
    func showError(message: String) {
        viewController.showError(message: message)
    }
    
    
}
