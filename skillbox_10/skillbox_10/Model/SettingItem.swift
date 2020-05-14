//
//  SettingItem.swift
//  skillbox_10
//
//  Created by Максим Кузнецов on 10.05.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

struct SettingItem {
    let type: SettingCellType
    let icon: UIImage?
    let title: String
    let disclosureTitle: String?
}

enum SettingCellType {
    case SwitchCell
    case DisclosureCell
}
