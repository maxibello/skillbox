//
//  ToDoListViewModel.swift
//  s02e04_mvvm
//
//  Created by Максим on 25.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

class ToDoListViewModel {
    
    var realm: Realm? {
        guard let realm = ServiceLocator.shared.get(Realm.self) else {
            return nil
        }
        return realm
    }
    
    var items = Observable<Results<ToDoItem>>.from([])
    
    init() {
        if let realm = self.realm {
            items = Observable.collection(from: realm.objects(ToDoItem.self))
        }
    }
    
    func save(_ itemText: String) -> Completable {
        return Completable.create(subscribe: { [unowned self] completable in
            do {
                try self.realm?.write({
                    let todoItem = ToDoItem()
                    todoItem.text = itemText
                    self.realm?.add(todoItem)
                })
                completable(.completed)
                return Disposables.create()
            } catch {
                completable(.error(error))
                return Disposables.create()
            }
        })
    }
    
    func delete(_ item: ToDoItem) -> Completable {
        return Completable.create(subscribe: { [unowned self] completable in
            
            do {
                try self.realm?.write({
                    self.realm?.delete(item)
                })
                completable(.completed)
                return Disposables.create()
            } catch {
                completable(.error(error))
                return Disposables.create()
            }
        })
    }
    
    
}
