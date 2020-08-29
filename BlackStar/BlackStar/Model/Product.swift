//
//  Product.swift
//  BlackStar
//
//  Created by Максим on 28.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Foundation

struct Product: Decodable {
    let name: String
    let sortOrder: String
    let description: String
    let mainImage: String
    let productImages: [ProductImage]
    let offers: [Offer]
    let price: String
    let article: String
    let colorName: String
    let id: String
    
    enum CodingKeys: CodingKey {
        case name
        case sortOrder
        case description
        case mainImage
        case productImages
        case offers
        case price
        case article
        case colorName
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 3
        // Decode firstName & lastName
        name = try container.decode(String.self, forKey: .name)
        sortOrder = try container.decode(String.self, forKey: .sortOrder)
        description = try container.decode(String.self, forKey: .description)
        mainImage = try container.decode(String.self, forKey: .mainImage)
        productImages = try container.decode([ProductImage].self, forKey: .productImages)
        offers = try container.decode([Offer].self, forKey: .offers)
        price = try container.decode(String.self, forKey: .price)
        article = try container.decode(String.self, forKey: .article)
        colorName = try container.decode(String.self, forKey: .colorName)
        id = container.codingPath.first!.stringValue
    }
}

struct ProductImage: Decodable {
    let imageURL: String
    let sortOrder: String
}

struct Offer: Decodable {
    let size: String
    let productOfferID: String
    let quantity: String
}
