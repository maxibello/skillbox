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
    var outputDelegate: ToDoListPresenterOutput? { get set }
    var interactor: ToDoListInteractorInput? { get set }
    
    func deleteItem(with indexPath: IndexPath)
    func addItem(with text: String)
    func fetchItems()
}

protocol ToDoListPresenterOutput {
    func updateItems()
    func handleError(message: String)
    func itemDeleted(at row: Int)
    func errorOccured(message: String)
}

class ToDoListPresenter: ToDoListPresenterInput {
    
    var items: Results<ToDoItem>?
    var outputDelegate: ToDoListPresenterOutput?
    var interactor: ToDoListInteractorInput?
    
    func fetchItems() {
        interactor?.fetchItems()
    }
    
    func deleteItem(with indexPath: IndexPath) {
        interactor?.deleteItem(with: indexPath.row)
    }
    
    func addItem(with text: String) {
        interactor?.addItem(with: text)
    }
    
}

extension ToDoListPresenter: ToDoListInteractorOutput {
    func errorOccured(message: String) {
        outputDelegate?.errorOccured(message: message)
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
        outputDelegate?.handleError(message: message)
    }
    
    
}
