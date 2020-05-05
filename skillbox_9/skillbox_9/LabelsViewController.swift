//
//  LabelsViewController.swift
//  skillbox_9
//
//  Created by Максим Кузнецов on 05.05.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class LabelsViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    var collapsed: Bool = false
    
    @IBOutlet weak var labelHeight: NSLayoutConstraint!
    
    @IBAction func changeLabelHeight(_ sender: Any) {
        collapsed.toggle()
        if collapsed {
            labelHeight.constant = 21
            button.setTitle("Развернуть", for: .normal)
        } else {
            labelHeight.constant = 21 * 5
            button.setTitle("Свернуть", for: .normal)
        }

    }

}
