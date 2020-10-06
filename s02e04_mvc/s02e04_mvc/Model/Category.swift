//
//  Categor.swift
//  BlackStar
//
//  Created by Максим on 27.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Foundation

struct Category: Decodable {
    let name: String
    let sortOrder: String
    let iconImage: String
    let subcategories: [Category]?
    let id: String
    
    enum CodingKeys: CodingKey {
        case name
        case sortOrder
        case iconImage
        case subcategories
        case id
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: CodingKeys.name)
        iconImage = try container.decode(String.self, forKey: CodingKeys.iconImage)

        do {
            sortOrder = try String(container.decode(String.self, forKey: .sortOrder))
        } catch DecodingError.typeMismatch {
            let intSortOrder = try container.decode(Int.self, forKey: .sortOrder)
            sortOrder = "\(intSortOrder)"
        }
        
        subcategories = try container.decodeIfPresent([Category].self, forKey: .subcategories)
        if subcategories != nil {
            id = container.codingPath.first?.stringValue ?? ""
        } else {
            do {
                id = try String(container.decode(String.self, forKey: .id))
            } catch DecodingError.typeMismatch {
                let intId = try container.decode(Int.self, forKey: .id)
                id = "\(intId)"
            }
        }
        
    }
}

struct DecodedArray<T:Decodable>: Decodable {
    typealias DecodedArrayType = [T]

    // ***
    private var array: DecodedArrayType
    
    // Define DynamicCodingKeys type needed for creating
    // decoding container from JSONDecoder
    private struct DynamicCodingKeys: CodingKey {
        
        // Use for string-keyed dictionary
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        // Use for integer-keyed dictionary
        var intValue: Int?
        init?(intValue: Int) {
            // We are not using this, thus just return nil
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        
        // 1
        // Create a decoding container using DynamicCodingKeys
        // The container will contain all the JSON first level key
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        var tempArray = DecodedArrayType()
        
        // 2
        // Loop through each key (student ID) in container
        for key in container.allKeys {
            
            // Decode Student using key & keep decoded Student object in tempArray
            let decodedObject = try container.decode(T.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }
        
        // 3
        // Finish decoding all Student objects. Thus assign tempArray to array.
        array = tempArray
    }
}

extension DecodedArray: Collection {

    // Required nested types, that tell Swift what our collection contains
    typealias Index = DecodedArrayType.Index
    typealias Element = DecodedArrayType.Element

    // The upper and lower bounds of the collection, used in iterations
    var startIndex: Index { return array.startIndex }
    var endIndex: Index { return array.endIndex }

    // Required subscript, based on a dictionary index
    subscript(index: Index) -> Iterator.Element {
        get { return array[index] }
    }

    // Method that returns the next index when iterating
    func index(after i: Index) -> Index {
        return array.index(after: i)
    }
}
