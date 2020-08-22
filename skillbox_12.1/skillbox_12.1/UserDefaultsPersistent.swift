//
//  UserDefaultsPersistent.swift
//  skillbox_12.1
//
//  Created by Максим on 05.08.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import Foundation

class UserDefaultsPersistent {
    static let shared = UserDefaultsPersistent()
    
    enum CodingKeys: String {
        case lastCachedPage = "UserDefaultsPersistent.lastCachedPage"
    }
    
    var lastCachedPage: Int? {
        set { UserDefaults.standard.set(newValue, forKey: CodingKeys.lastCachedPage.rawValue) }
        get { UserDefaults.standard.integer(forKey: CodingKeys.lastCachedPage.rawValue) }
    }
    
}

