//
//  ToDoListInteractor.swift
//  s02e04_viper
//
//  Created by Максим on 27.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Foundation
import RealmSwift

protocol ToDoListInteractorInput {
    func fetchItems()
    func deleteItem(with id: Int)
    func addItem(with text: String)
}

protocol ToDoListInteractorOutput {
    func itemsDidFetched(items: Results<ToDoItem>)
    func fetchingDidError(message: String)
    func itemDeleted(at row: Int)
    func itemAdded()
    func errorOccured(message: String)
}

class ToDoListInteractor: ToDoListInteractorInput {
    
    var items: Results<ToDoItem>?
    var outputDelegate: ToDoListInteractorOutput?
    
    var realm: Realm? {
        guard let realm = ServiceLocator.shared.get(Realm.self) else {
            return nil
        }
        return realm
    }
    
    func addItem(with text: String) {
        do {
            try self.realm?.write({
                let todoItem = ToDoItem()
                todoItem.text = text
                self.realm?.add(todoItem)
            })
            outputDelegate?.itemAdded()
        } catch {
            outputDelegate?.errorOccured(message: error.localizedDescription)
        }

    }
    
    func deleteItem(with id: Int) {
        guard let items = items else { return }
        do {
            try realm?.write({
                realm?.delete(items[id])
            })
            outputDelegate?.itemDeleted(at: id)
        } catch {
            outputDelegate?.errorOccured(message: error.localizedDescription)
        }
    }
    
    func fetchItems() {
        guard let realm = self.realm else {
            outputDelegate?.fetchingDidError(message: "Realm error")
            return
        }
        let fetchedItems = realm.objects(ToDoItem.self)
        outputDelegate?.itemsDidFetched(items: fetchedItems)
        items = fetchedItems
    }
}
