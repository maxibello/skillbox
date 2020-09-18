//
//  FirstLaunch.swift
//  skillbox_14
//
//  Created by Максим on 31.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import Foundation
import CoreData
import RealmSwift

class FirstLaunch {
    
    static func initializeDefaultDbData() {
        guard
            let persistent = ServiceLocator.shared.get(UserDefaultsPersistent.self),
            let realm = ServiceLocator.shared.get(Realm.self)
            else { return }
        
        if persistent.realmFirstLaunch == false {
            do {
                try realm.write({
                    ["Finish skillbox course", "Clean teeth", "Have a shower"].forEach({ task in
                        let todoItem = ToDoItem()
                        todoItem.text = task
                        realm.add(todoItem)
                    })
                })
                persistent.realmFirstLaunch = true
            } catch {
                print(error.localizedDescription)
            }
        }
                   
    }
}
