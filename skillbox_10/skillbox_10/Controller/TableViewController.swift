//
//  TableViewController.swift
//  skillbox_10
//
//  Created by Максим Кузнецов on 10.05.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    let items: [[SettingItem]] = [
        [SettingItem(type: .SwitchCell, icon: UIImage(named: "airplane mode.png"), title: "Авиарежим ", disclosureTitle: nil),
         SettingItem(type: .DisclosureCell, icon: UIImage(named: "wifi.png"), title: "Wi-Fi", disclosureTitle: "Anvics-YOTA"),
         SettingItem(type: .DisclosureCell, icon: UIImage(named: "bluetooth.png"), title: "Bluetooth", disclosureTitle: nil),
         SettingItem(type: .DisclosureCell, icon: UIImage(named: "cellular.png"), title: "Сотовая связь", disclosureTitle: nil),
         SettingItem(type: .DisclosureCell, icon: UIImage(named: "hotspot.png"), title: "Режим модема", disclosureTitle: nil)
        ],
        [
            SettingItem(type: .DisclosureCell, icon: UIImage(named: "notifications.png"), title: "Уведомления", disclosureTitle: nil),
            SettingItem(type: .DisclosureCell, icon: UIImage(named: "do not disturb.png"), title: "Не беспокоить", disclosureTitle: nil)
        ],
        [
            SettingItem(type: .DisclosureCell, icon: UIImage(named: "control center.png"), title: "Основные", disclosureTitle: nil)
        ]
    
    ]

}

extension TableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = items[indexPath.section][indexPath.row]
        
        switch currentItem.type {
        case .SwitchCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSwitch") as! SwitchViewCell
            cell.configure(with: currentItem)
            return cell
        case .DisclosureCell:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellDisclosure") as! DisclosureViewCell
            cell.configure(with: currentItem)
            return cell
        }
    }
    
    
}
