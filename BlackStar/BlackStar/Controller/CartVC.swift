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

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeBarItem: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        navBar.barTintColor = .white
        closeBarItem.image = UIImage(named: "closeBtn")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
    
    @IBAction func closeCart(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func deleteItem(_ sender: UIButton) {
//        items.remove(at:sender.tag)
        cartDBManager.remove(cart: items[sender.tag])
        self.tableView.reloadData()
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
