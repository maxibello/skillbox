//
//  CartItem.swift
//  BlackStar
//
//  Created by Максим on 01.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Foundation
import RealmSwift

class CartItem: Object, Decodable {
    @objc dynamic var name: String = ""
    @objc dynamic var price: String = ""
    @objc dynamic var color: String = ""
//    @objc dynamic var offer: Offer
}
