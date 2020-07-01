//
//  ViewController.swift
//  skillbox_11.1
//
//  Created by Максим Кузнецов on 16.06.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let roundedSwitch = CustomSwitch(frame: CGRect(x: 50, y: 50, width: 80, height: 30))
        roundedSwitch.padding = 5
        let rectangledSwitch = CustomSwitch(frame: CGRect(x: 50, y: 50, width: 80, height: 30))
        rectangledSwitch.center.y += 40
        rectangledSwitch.textOn = "✓"
        rectangledSwitch.cornerRadius = 0.1
        rectangledSwitch.thumbCornerRadius = 0
        rectangledSwitch.padding = 0
        rectangledSwitch.thumbSize = CGSize(width: rectangledSwitch.bounds.height, height: rectangledSwitch.bounds.height)
        
        let passwordTextField = CustomTextField(frame: CGRect(x: 50, y: 200, width: 200, height: 200))
        
        let battery = Battery(frame: CGRect(x: 100, y: 300, width: 200, height: 300))
        battery.capacityValue = 0.25
        
        view.addSubview(roundedSwitch)
        view.addSubview(rectangledSwitch)
        view.addSubview(passwordTextField)
        view.addSubview(battery)
    }

}

