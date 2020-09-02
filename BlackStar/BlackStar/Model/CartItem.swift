//
//  CartItem.swift
//  BlackStar
//
//  Created by Максим on 01.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Foundation
import RealmSwift

//po Realm.Configuration.defaultConfiguration.fileURL

class CartItem: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var price: String = ""
    @objc dynamic var color: String = ""
    
    @objc private dynamic var offerData:Data? = nil
    var offer : Offer? {
        get {
            if let data = offerData {
                return try! JSONDecoder().decode(Offer.self, from: data)
            }
            return nil
        }
        set {
            offerData = try? JSONEncoder().encode(newValue)
        }
    }
    
    var localImagePath: URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let offer = offer else { return nil }
        let filePath = paths.first?.appendingPathComponent("\(offer.productOfferID).png")
        return filePath
    }
    
    var localImage: UIImage? {
        if let url = localImagePath {
            if let data =  try? Data(contentsOf: url) {
                return UIImage(data: data)
            }
        }
        return nil
    }
    
    private func saveLocalImage(_ image: UIImage) {
        guard let filePath = localImagePath else { return }
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try image.pngData()?.write(to: filePath, options: .atomic)
            } catch {
                print("Error saving local image")
            }
        }
    }
    
    init(from formedProduct: FormedProduct,
         color: String,
         offer: Offer,
         image: UIImage?) {
        super.init()
        self.name = formedProduct.frontProduct.name
        self.price = formedProduct.frontProduct.price
        self.color = color
        self.offer = offer
        if let image = image {
           saveLocalImage(image)
        }
    }
    
    required init() {
//        fatalError("init() has not been implemented")
        super.init()
    }
}
