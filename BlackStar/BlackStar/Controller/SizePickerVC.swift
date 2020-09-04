//
//  SizePickerVC.swift
//  BlackStar
//
//  Created by Максим on 30.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

protocol SizePickerDelegate {
    func didPickSize(_: SizePickerVC, color: String, offer: Offer)
}

class SizePickerVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var offers: [(String, [Offer])] = []
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
        return offers[section].1.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return offers[section].0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ColorOffersViewCell
        cell.configure(with: offers[indexPath.section].1[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! ColorOffersViewCell
        cell.checkmarkImageView.image = #imageLiteral(resourceName: "doneIcon")
        
        let color = offers[indexPath.section].0
        let offer = offers[indexPath.section].1[indexPath.row]
        delegate?.didPickSize(self, color: color, offer: offer)
    }
}
