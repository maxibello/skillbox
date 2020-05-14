//
//  DisclosureViewCell.swift
//  skillbox_10
//
//  Created by Максим Кузнецов on 10.05.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class DisclosureViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var disclosure: UILabel!
    
    func configure(with item: SettingItem) {
        icon.image = item.icon
        title.text = item.title
        disclosure.text = item.disclosureTitle
    }

}
