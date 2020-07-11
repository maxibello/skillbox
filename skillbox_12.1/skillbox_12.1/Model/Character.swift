//
//  Character.swift
//  skillbox_12.1
//
//  Created by Максим Кузнецов on 06.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import Foundation

struct Character: Decodable {
    let id: Int
    let name: String
    let species: String
    let image: String
}

struct Characters: Decodable {
    let results: [Character]
    let info: Info
}

struct Info: Decodable {
    let count: Int
    let pages: Int
}
