//
//  AdditionalViewController.swift
//  skillbox_8
//
//  Created by Максим Кузнецов on 01.05.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class AdditionalViewController: UIViewController {

    let dateFormatter = DateFormatter()
    var currentDate: Date = Date()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy HH:mm")
        updateLabel()
    }
    
    @IBAction func changeDate(_ sender: UIDatePicker) {
        currentDate = sender.date
        updateLabel()
    }
    
    @IBAction func changeTimeZone(_ sender: UITextField) {
        if let text = sender.text,
        let zoneNumber = Int(text),
            (-12...12).contains(zoneNumber) {
            let selectedTimeZone = TimeZone(secondsFromGMT: 3600 * zoneNumber)
            dateFormatter.timeZone = selectedTimeZone
        } else {
            dateFormatter.timeZone = TimeZone.current
        }
        updateLabel()
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            imageView.alpha = 1
            activityIndicator.stopAnimating()
        } else {
            imageView.alpha = 0.3
            activityIndicator.startAnimating()
        }
    }
    
    private func updateLabel() {
        dateLabel.text = dateFormatter.string(from: currentDate)
    }

}
