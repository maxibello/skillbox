//
//  CartVC.swift
//  BlackStar
//
//  Created by Максим on 01.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit
import RealmSwift

class CartVC: UIViewController {

    let cartDBManager = CartDBManager.shared
    lazy var items: Results<CartItem> = { return cartDBManager.getAllCartItems() }()
    var selectedCart: CartItem?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeBarItem: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var finalPriceLabel: UILabel!
    
    var finalPrice: String {
        guard items.count > 0 else { return "0 ₽" }
        
        var price: Decimal = 0
        for item in items {
            if let itemPrice = Decimal(string: item.price) {
                price += itemPrice
            }
        }
    
        return "\(price) ₽"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        navBar.barTintColor = .white
        closeBarItem.image = UIImage(named: "closeBtn")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        updatePrice()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CartAlert", let cartAlertVC = segue.destination as? CartAlertVC {
            cartAlertVC.okAction = { [weak self] in
                guard let self = self, let selectedCart = self.selectedCart else { return }
                self.cartDBManager.remove(cart: selectedCart)
                
                self.tableView.reloadData()
                self.updatePrice()
            }
        }
    }
    
    @IBAction func closeCart(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        selectedCart = items[sender.tag]
    }
    
    private func updatePrice() {
        finalPriceLabel.text = finalPrice
    }
    
}

extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell") as! CartItemViewCell
        cell.deleteButton.tag = indexPath.row
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCart = items[indexPath.row]
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
