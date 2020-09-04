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
//    var items: [CartItem] = []
    let cartDBManager = CartDBManager.shared
    lazy var items: Results<CartItem> = { return cartDBManager.getAllCartItems() }()
    var selectedCart: CartItem?
//    var alert: CartAlertView?
    
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
            }
        }
    }
    
    @IBAction func closeCart(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteCartItem() {
        guard let selectedCart = selectedCart else { return }
        cartDBManager.remove(cart: selectedCart)
        self.tableView.reloadData()
    }
    
    @objc func closeAlert() {
//        alert?.removeFromSuperview()
    }
    
    @IBAction func deleteItem(_ sender: UIButton) {
//        items.remove(at:sender.tag)
//        cartDBManager.remove(cart: items[sender.tag])
        selectedCart = items[sender.tag]
//        alert = CartAlertView()
//        guard let alert = alert else { return }
//        alert.okButton.addTarget(self, action: #selector(deleteCartItem), for: .touchUpInside)
//        alert.cancelButton.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
//        view.addSubview(alert)
        
        updatePrice()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        print("Shit")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
