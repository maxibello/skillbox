//
//  CharactersResponse.swift
//  skillbox_12.1
//
//  Created by Максим Кузнецов on 11.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import Foundation

struct CharactersResponse {
    var allCount: Int
    var pageCount: Int
    var page: [Character]
    
    enum CodingKeys: String, CodingKey {
        case page = "results"
        case info
    }
    
    enum InfoKeys: String, CodingKey {
        case count
        case pages
    }
}

extension CharactersResponse: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decode([Character].self, forKey: .page)
        
        let info = try values.nestedContainer(keyedBy: InfoKeys.self, forKey: .info)
        allCount = try info.decode(Int.self, forKey: .count)
        pageCount = try info.decode(Int.self, forKey: .pages)
    }
}
