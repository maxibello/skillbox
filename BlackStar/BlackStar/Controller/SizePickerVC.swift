//
//  SizePickerVC.swift
//  BlackStar
//
//  Created by Максим on 30.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

typealias SizeOption = (colorName: String, colorURL: String, offers: [Offer])

protocol SizePickerDelegate {
    func didPickSize(_: SizePickerVC, color: String, offer: Offer)
}

class SizePickerVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var options: [SizeOption] = []
    let cellID = "ColorOffersViewCell"
    var delegate: SizePickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ColorOffersView", bundle: nil), forCellReuseIdentifier: cellID)
    }
}

extension SizePickerVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options[section].offers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return options[section].colorName
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ColorOffersViewCell
        cell.configure(with: options[indexPath.section].offers[indexPath.row],
                       colorURL: options[indexPath.section].colorURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! ColorOffersViewCell
        cell.checkmarkImageView.image = #imageLiteral(resourceName: "doneIcon")
        
        let color = options[indexPath.section].colorName
        let offer = options[indexPath.section].offers[indexPath.row]
        delegate?.didPickSize(self, color: color, offer: offer)
    }
}
