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
    
    var realm: Realm? {
        guard let realm = ServiceLocator.shared.get(Realm.self) else {
            let errorVC = ErrorOverlayVC()
            errorVC.modalPresentationStyle = .overCurrentContext
            errorVC.modalTransitionStyle = .coverVertical
            errorVC.delegate = self
            errorVC.errorMessage = "Realm initialization error"
            present(errorVC, animated: true, completion: nil)
            return nil
        }
        return realm
    }
    
    lazy var itemsToDo: Results<ToDoItem>? = {
        if let realm = self.realm {
            return realm.objects(ToDoItem.self)
        }
        return nil
        }()
    let persistent = UserDefaultsPersistent.shared
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToDo?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell")!
        cell.textLabel?.text = itemsToDo?[indexPath.row].text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete, let itemsToDo = itemsToDo else { return }
            do {
                try realm?.write({
                    realm?.delete(itemsToDo[indexPath.row])
                })
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                showError(message: error.localizedDescription)
            }
            
        
    }
    
    @IBAction func addNewTask(_ sender: Any) {
        let alert = UIAlertController(title: "New task", message: "Type what you want to do", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] action in
            guard let self = self, let textField = alert?.textFields?.first else {
                return
            }
            if let text = textField.text, text.count > 0 {
                do {
                    try self.realm?.write({
                        let todoItem = ToDoItem()
                        todoItem.text = text
                        self.realm?.add(todoItem)
                    })
                    self.tableView.reloadData()
                } catch {
                    self.showError(message: error.localizedDescription)
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ToDoListViewController: ErrorOverlayDismissing {
    func didCloseErrorVC(_: ErrorOverlayVC) {
        dismiss(animated: true, completion: nil)
    }
}
