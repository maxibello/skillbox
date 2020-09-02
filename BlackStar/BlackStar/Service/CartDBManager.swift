//
//  CartDBManager.swift
//  BlackStar
//
//  Created by Максим on 01.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import RealmSwift

class CartDBManager {
    static let shared = CartDBManager()
    private var database: Realm
    
    private init() {
        database = try! Realm()
    }
    
    func getAllCartItems() ->   Results<CartItem> {
        let results: Results<CartItem> = database.objects(CartItem.self)
        return results
    }
    
    func add(cart: CartItem) {
        
        try! database.write {
            database.add(cart)
            print("Added new object")
        }
    }
    
    func remove(cart: CartItem) {
        try! database.write {
            database.delete(cart)
            print("Removed object")
        }
    }
}
