//
//  WeekDayCellTableViewCell.swift
//  skillbox_12
//
//  Created by Максим Кузнецов on 14.06.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class WeekDayCell: UITableViewCell {
    
    @IBOutlet weak var weatherMainLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var dayTempLabel: UILabel!
    @IBOutlet weak var nightTempLabel: UILabel!
    
    func configure(with model: DailyWeather) {
        weatherMainLabel.text = model.weather.first?.main
        weatherDescriptionLabel.text = model.weather.first?.formattedDesctiption
        dayTempLabel.text = "\(model.temp.day.tempCelsius)℃"
        nightTempLabel.text = "\(model.temp.night.tempCelsius)℃"
        
    }

}
