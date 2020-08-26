//
//  DBManager.swift
//  skillbox_12.1
//
//  Created by Максим on 05.08.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import Foundation
import RealmSwift

class CharacterDB {
    private var database: Realm
    static let sharedInstance = CharacterDB()
    
    private init() {
        database = try! Realm()
    }
    
    func getDataFromDB() ->   Results<Character> {
        let results: Results<Character> = database.objects(Character.self)
        return results
    }

    func addObjects(objects: [Character]) {
        
        try! database.write {
            database.add(objects, update: .modified)
            print("Added new object")
        }
    }
    
    func edit(object: Character, name: String, species: String, localRevision: Bool, completion: @escaping () -> Void) {
        database.writeAsync(obj: object, completion: completion) { (realm, object) in
            guard let object = object else { return }
            object.name = name
            object.species = species
            object.localRevision = localRevision
        }
    }
    
}

extension Realm {
    func writeAsync<T : ThreadConfined>(obj: T,
                                        completion: @escaping () -> Void,
                                        errorHandler: @escaping ((_ error : Swift.Error) -> Void) = { _ in return },
                                        block: @escaping ((Realm, T?) -> Void)) {
        let wrappedObj = ThreadSafeReference(to: obj)
        let config = self.configuration
        DispatchQueue(label: "background").async {
            autoreleasepool {
                do {
                    let realm = try Realm(configuration: config)
                    let obj = realm.resolve(wrappedObj)

                    try realm.write {
                        block(realm, obj)
                    }
                    
                    DispatchQueue.main.async {
                        completion()
                    }
                }
                catch {
                    errorHandler(error)
                }
            }
        }
    }
}
