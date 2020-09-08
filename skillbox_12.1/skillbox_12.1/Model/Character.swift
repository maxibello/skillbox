//
//  Character.swift
//  skillbox_12.1
//
//  Created by Максим Кузнецов on 06.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import Foundation
import RealmSwift

struct Characters: Decodable {
    let results: [Character]
    let info: Info
}

struct Info: Decodable {
    let count: Int
    let pages: Int
}

class Character: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var species: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var localRevision: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case id, name, species, image
    }
    
    var localImagePath: URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filePath = paths.first?.appendingPathComponent("\(id).png")
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
    
    var tempImage: UIImage?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
      return ["localImagePath", "localImage", "tempImage"]
    }
    
    func saveLocalImage(_ image: UIImage) {
        guard let filePath = localImagePath else { return }
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try image.pngData()?.write(to: filePath, options: .atomic)
            } catch {
                print("Error saving local image")
            }
        }
    }
}
