//
//  UserDefaultsPersistent.swift
//  skillbox_14
//
//  Created by Максим Кузнецов on 12.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import Foundation

class UserDefaultsPersistent {
    static let shared = UserDefaultsPersistent()
    
    enum CodingKeys: String {
        case firstname = "UserDefaultsPersistent.firstname"
        case lastname = "UserDefaultsPersistent.lastname"
    }
    
    var firstname: String? {
        set { UserDefaults.standard.set(newValue, forKey: CodingKeys.firstname.rawValue) }
        get { UserDefaults.standard.string(forKey: CodingKeys.firstname.rawValue) }
    }
    
    var lastname: String? {
        set { UserDefaults.standard.set(newValue, forKey: CodingKeys.lastname.rawValue) }
        get { UserDefaults.standard.string(forKey: CodingKeys.lastname.rawValue) }
    }
    
}
