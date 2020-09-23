//
//  NameCell.swift
//  s02e03_Reactive
//
//  Created by Максим on 14.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class NameCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    static let identifier = "NameCell"
    
    func configure(with name: String) {
        nameLabel.text = name
    }
}
