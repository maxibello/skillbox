//
//  WeeklyCityController.swift
//  skillbox_12
//
//  Created by Максим Кузнецов on 14.06.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class WeeklyCityController: UITableViewController {
    
    var items: [DailyWeather] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekDayCell") as! WeekDayCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    private func loadData() {
        WeatherLoader().weeklyCityLoader() { [weak self] result in
            switch result {
            case .success(let weeklyWeather):
                self?.items = weeklyWeather.list
                self?.tableView.reloadData()
            case .failure(let networkError):
                let alert = UIAlertController(title: "Network Error", message: networkError.localizedDescription, preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                    self?.loadData()
                })
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(retryAction)
                alert.addAction(okAction)
                self?.present(alert, animated: true)
            }
        }
    }
}
