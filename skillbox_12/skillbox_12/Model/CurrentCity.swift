//
//  CurrentWeather.swift
//  skillbox_12
//
//  Created by Максим Кузнецов on 12.06.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import Foundation

struct CurrentCity: Decodable {
    let weather: [WeatherDescription]
    let main: WeatherInfo
    let name: String
}

struct WeatherDescription: Decodable {
    
    var formattedDesctiption: String {
        return description.prefix(1).capitalized + description.dropFirst()
    }
    
    let main: String
    let description: String
}

struct WeatherInfo: Decodable {
    
    let temp: Float
    let feels_like: Float
    let pressure: Int
    let humidity: Int
}

extension Float {
    var tempCelsius: Int {
        return Int(self - 273.15)
    }
}
