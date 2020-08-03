//
//  WeatherLoader.swift
//  skillbox_14
//
//  Created by Максим Кузнецов on 15.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import Foundation

class WeatherLoader {
    func currentCityLoader(completion: @escaping (Result<CurrentCity, Error>) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=moscow&appid=3a4b63153cfe906902828d5828a97054") else { return }
        URLSession.shared.dataTask(with: url) { (data, response
            , error) in
            if let networkError = error {
                DispatchQueue.main.async {
                    completion(.failure(networkError))
                }
            }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(CurrentCity.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
