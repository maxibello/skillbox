//
//  CurrentCIty.swift
//  skillbox_14
//
//  Created by Максим Кузнецов on 15.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import Foundation
import RealmSwift

class CurrentCity: Object, Decodable {
    var weather = List<WeatherDescription>()
    @objc dynamic var main: WeatherInfo?
    @objc dynamic var name: String = ""
}

class WeatherDescription: Object, Decodable {
    
    var formattedDesctiption: String {
        return desc.prefix(1).capitalized + desc.dropFirst()
    }
    
    @objc dynamic var main: String = ""
    @objc dynamic var desc: String = ""
    
    enum CodingKeys: String, CodingKey {
        case main
        case desc = "description"
    }
}

class WeatherInfo: Object, Decodable {
    @objc dynamic var temp: Float = 0
    @objc dynamic var feelsLike: Float = 0
    @objc dynamic var pressure: Int = 0
    @objc dynamic var humidity: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case pressure
        case humidity
    }
}

extension Float {
    var tempCelsius: Int {
        return Int(self - 273.15)
    }
}

//extension List : Decodable where Element : Decodable {
//    public convenience init(from decoder: Decoder) throws {
//        self.init()
//        var container = try decoder.unkeyedContainer()
//        while !container.isAtEnd {
//            let element = try container.decode(Element.self)
//            self.append(element)
//        }
//    } }
//
//extension List : Encodable where Element : Encodable {
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.unkeyedContainer()
//        for element in self {
//            try element.encode(to: container.superEncoder())
//        }
//    } }
