//
//  ViewController.swift
//  skillbox_12
//
//  Created by Максим Кузнецов on 07.06.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit
//import Alamofire

class CurrentCityController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        WeatherLoader().currentCityLoader() { [weak self] currentCity in
            self?.activityIndicator.stopAnimating()
            self?.updateUI(with: currentCity)
        }
    }
    
    func updateUI(with city: CurrentCity) {
        cityLabel.text = city.name
        weatherDescriptionLabel.text = city.weather.first?.formattedDesctiption
        tempLabel.text = "\(city.main.temp.tempCelsius) ℃"
        
        cityLabel.isHidden = false
        weatherDescriptionLabel.isHidden = false
        tempLabel.isHidden = false
    }

}

