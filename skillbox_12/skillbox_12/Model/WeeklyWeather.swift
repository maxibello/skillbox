//
//  WeeklyWeather.swift
//  skillbox_12
//
//  Created by Максим Кузнецов on 14.06.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import Foundation

struct WeeklyWeather: Decodable {
    let list: [DailyWeather]
}

struct DailyWeather: Decodable {
    let temp: DailyTemperature
    let weather: [WeatherDescription]
}

struct DailyTemperature: Decodable {
    let day: Float
    let night: Float
}
