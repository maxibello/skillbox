//
//  DBManager.swift
//  skillbox_12.1
//
//  Created by Максим on 05.08.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    private var database: Realm
    static let sharedInstance = DBManager()
    
    private init() {
        database = try! Realm()
    }
    
    func getDataFromDB() ->   Results<Character> {
        let results: Results<Character> = database.objects(Character.self)
        return results
    }
//    func addData(object: Character)   {
//        try! database.write {
//            database.add(object)
//            print("Added new object")
//        }
//    }
    
//    func addObjects(objects: List<Character>) {
//        try! database.write {
//            database.add(objects, update: .all)
//            print("Added new objects")
//        }
//    }
//
    func addObjects(objects: [Character]) {
        
        try! database.write {
            database.add(objects, update: .modified)
            print("Added new object")
        }
    }
    
    func edit(object: Character, closure: () -> Void) {
        try! database.write {
            closure()
        }
    }
    
    func deleteAllFromDatabase()  {
        try! database.write {
            database.deleteAll()
        }
    }
    func deleteFromDb(object: Character)   {
        try! database.write {
            database.delete(object)
        }
    }
}
