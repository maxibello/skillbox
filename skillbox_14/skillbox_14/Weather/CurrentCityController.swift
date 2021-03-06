//
//  CurrentCityController.swift
//  skillbox_14
//
//  Created by Максим Кузнецов on 15.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit
import RealmSwift

class CurrentCityController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var realm: Realm? {
        guard let realm = ServiceLocator.shared.get(Realm.self) else {
            let errorVC = ErrorOverlayVC()
            errorVC.modalPresentationStyle = .overCurrentContext
            errorVC.modalTransitionStyle = .coverVertical
            errorVC.delegate = self
            errorVC.errorMessage = "Realm initialization error"
            present(errorVC, animated: true, completion: nil)
            return nil
        }
        return realm
    }
    
    var currentCity: CurrentCity?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromStorage()
        loadDataFromNetwork()
    }
    
    func updateUI(with city: CurrentCity) {
        cityLabel.text = city.name
        weatherDescriptionLabel.text = city.weather.first?.formattedDesctiption
        if let temp = city.main?.temp {
            tempLabel.text = "\(temp.tempCelsius) ℃"
        }
        
        cityLabel.isHidden = cityLabel.isHidden ? false : cityLabel.isHidden
        weatherDescriptionLabel.isHidden = false
        tempLabel.isHidden = tempLabel.isHidden ? false : tempLabel.isHidden
    }
    
    private func loadDataFromStorage() {
        currentCity = realm?.objects(CurrentCity.self).first
        if let currentCity = currentCity {
            updateUI(with: currentCity)
        }
    }
    
    private func loadDataFromNetwork() {
        activityIndicator.startAnimating()
        WeatherLoader().currentCityLoader() { [weak self] result in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            switch result {
            case .success(let downloadedCity):
                self.updateUI(with: downloadedCity)
                do {
                    try self.realm?.write({
                        if let cachedCity = self.currentCity {
                            self.realm?.delete(cachedCity)
                        }
                        self.realm?.add(downloadedCity)
                    })
                } catch {
                    self.showError(message: error.localizedDescription)
                }
                
            case .failure(let error):
                let alert = UIAlertController(title: "Network Error", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                    self?.activityIndicator.startAnimating()
                    self?.loadDataFromNetwork()
                })
                alert.addAction(retryAction)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
        }
    }
    
}

extension CurrentCityController: ErrorOverlayDismissing {
    func didCloseErrorVC(_: ErrorOverlayVC) {
        dismiss(animated: true, completion: nil)
    }
}
