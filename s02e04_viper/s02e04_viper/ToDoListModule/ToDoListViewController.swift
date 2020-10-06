//
//  ToDoListViewController.swift
//  skillbox_14
//
//  Created by Максим Кузнецов on 14.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var presenter: ToDoListPresenterInput!
    let configurator: TDLConfiguratorProtocol = TDLConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.fetchItems()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell")!
        cell.textLabel?.text = presenter.items?[indexPath.row].text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        presenter.deleteItem(with: indexPath)
    }
    
    @IBAction func addNewTask(_ sender: Any) {
        presenter.showAddItemAlert()
    }
}

extension ToDoListViewController: ToDoListPresenterOutput {
    func errorOccured(message: String) {
        showError(message: message)
    }
    
    func itemDeleted(at row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func updateItems() {
        tableView.reloadData()
    }
}
