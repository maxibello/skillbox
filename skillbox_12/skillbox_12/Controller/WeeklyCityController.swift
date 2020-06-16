//
//  WeeklyCityController.swift
//  skillbox_12
//
//  Created by Максим Кузнецов on 14.06.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class WeeklyCityController: UITableViewController {
    
    var items: [DailyWeather]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherLoader().weeklyCityLoader() { [weak self] weeklyWeather in
            self?.items = weeklyWeather.list
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekDayCell") as! WeekDayCell
        if let model = items?[indexPath.row] {
            cell.configure(with: model)
        }
        return cell
    }
}
