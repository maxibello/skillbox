//
//  ViewController.swift
//  skillbox_12
//
//  Created by Максим Кузнецов on 07.06.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class CurrentCityController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func updateUI(with city: CurrentCity) {
        cityLabel.text = city.name
        weatherDescriptionLabel.text = city.weather.first?.formattedDesctiption
        tempLabel.text = "\(city.main.temp.tempCelsius) ℃"
        
        cityLabel.isHidden = false
        weatherDescriptionLabel.isHidden = false
        tempLabel.isHidden = false
    }
    
    private func loadData() {
        WeatherLoader().currentCityLoader() { [weak self] result in
            self?.activityIndicator.stopAnimating()
            switch result {
            case .success(let currentCity):
                self?.updateUI(with: currentCity)
            case .failure(let error):
                let alert = UIAlertController(title: "Network Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                    self?.activityIndicator.startAnimating()
                    self?.loadData()
                })
                alert.addAction(retryAction)
                alert.addAction(okAction)
                self?.present(alert, animated: true)
            }
        }
    }
    
}

