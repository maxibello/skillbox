//
//  ToDoListPresenter.swift
//  s02e04_viper
//
//  Created by Максим on 27.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Foundation
import RealmSwift

protocol ToDoListPresenterInput {
    var items: Results<ToDoItem>? { get set }
    func deleteItem(with indexPath: IndexPath)
    func addItem(with text: String)
    func showAddItemAlert()
    func fetchItems()
}

protocol ToDoListPresenterOutput {
    func updateItems()
    func itemDeleted(at row: Int)
}

class ToDoListPresenter: ToDoListPresenterInput {
    
    var items: Results<ToDoItem>?
    var outputDelegate: ToDoListPresenterOutput?
    private let interactor: ToDoListInteractorInput
    private let router: ToDoListRouterInput
    
    init(interactor: ToDoListInteractorInput, router: ToDoListRouterInput) {
        self.interactor = interactor
        self.router = router
    }
    
    func fetchItems() {
        interactor.fetchItems()
    }
    
    func deleteItem(with indexPath: IndexPath) {
        interactor.deleteItem(with: indexPath.row)
    }
    
    func addItem(with text: String) {
        interactor.addItem(with: text)
    }
    
    func showAddItemAlert() {
        router.showNewItemDialog(presenter: self)
    }
    
}

extension ToDoListPresenter: ToDoListInteractorOutput {
    func errorOccured(message: String) {
        router.showError(message: message)
    }

    func itemAdded() {
        outputDelegate?.updateItems()
    }
    
    func itemDeleted(at row: Int) {
        outputDelegate?.itemDeleted(at: row)
    }
    
    func itemsDidFetched(items: Results<ToDoItem>) {
        self.items = items
        outputDelegate?.updateItems()
    }
    
    func fetchingDidError(message: String) {
        router.showError(message: message)
    }
}
