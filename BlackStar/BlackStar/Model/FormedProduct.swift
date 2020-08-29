//
//  FormedProduct.swift
//  BlackStar
//
//  Created by Максим on 29.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Foundation

struct FormedProduct {
    let frontProduct: Product
    let photoGallery: [ProductImage]
    let offers: [String: [Offer]]

    
    init?(with products: [Product]) {
        guard let firstProduct = products.first else { return nil }
        self.frontProduct = firstProduct
        
        var photoGallery: [ProductImage] = []
        var offers: [String: [Offer]] = [:]
        for product in products {
            photoGallery += product.productImages
                .sorted(by: { Int($0.sortOrder) ?? Int.max < Int($1.sortOrder) ?? Int.max })
            offers[product.colorName] = product.offers
        }
        self.photoGallery = photoGallery
        self.offers = offers
    }
    
}
