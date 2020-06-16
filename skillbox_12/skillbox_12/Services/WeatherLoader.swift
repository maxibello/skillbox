//
//  WeatherLoader.swift
//  skillbox_12
//
//  Created by Максим Кузнецов on 12.06.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import Foundation
import Alamofire

class WeatherLoader {
    func currentCityLoader(completion: @escaping (CurrentCity) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=moscow&appid=3a4b63153cfe906902828d5828a97054") else { return }
        URLSession.shared.dataTask(with: url) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(CurrentCity.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedData)
                }
                
            } catch let error {
                print("Network error", error)
            }
        }.resume()
    }
    
    func weeklyCityLoader(completion: @escaping (WeeklyWeather) -> Void) {
        AF.request("https://api.openweathermap.org/data/2.5/forecast/daily?q=moscow&cnt=7&appid=3a4b63153cfe906902828d5828a97054")
        .validate()
        .responseDecodable(of: WeeklyWeather.self) { (response) in
          guard let weeklyWeather = response.value else { return }
//            print(weeklyWeather.city.name)
            completion(weeklyWeather)
        }

    }
}
