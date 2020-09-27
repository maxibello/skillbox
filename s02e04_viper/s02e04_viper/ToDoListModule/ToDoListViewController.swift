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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        presenter.fetchItems()
    }
    
    private func config() {
        presenter = ToDoListPresenter()
        presenter.outputDelegate = self
        
        let interactor = ToDoListInteractor()
        interactor.outputDelegate = presenter as? ToDoListPresenter
        presenter.interactor = interactor
        
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
        let alert = UIAlertController(title: "New task", message: "Type what you want to do", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] action in
            guard let self = self, let textField = alert?.textFields?.first else {
                return
            }
            if let text = textField.text, text.count > 0 {
                self.presenter.addItem(with: text)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
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
    
    func handleError(message: String) {
        showError(message: message)
    }
}
