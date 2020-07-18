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
    
    let realm = try! Realm()
    lazy var itemsToDo: Results<ToDoItem> = { self.realm.objects(ToDoItem.self) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateDefaultTodos()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsToDo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell")!
        cell.textLabel?.text = itemsToDo[indexPath.row].text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write({
                realm.delete(itemsToDo[indexPath.row])
            })
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func addNewTask(_ sender: Any) {
        let alert = UIAlertController(title: "New task", message: "Type what you want to do", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            guard let textField = alert.textFields?.first else {
                return
            }
            if let text = textField.text, text.count > 0 {
                try! self.realm.write({
                    let todoItem = ToDoItem()
                    todoItem.text = text
                    self.realm.add(todoItem)
                })
                self.tableView.reloadData()
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func populateDefaultTodos() {
        if itemsToDo.count == 0 {
            try! realm.write({
                ["Finish skillbox course", "Clean teeth", "Have a shower"].forEach({ task in
                    let todoItem = ToDoItem()
                    todoItem.text = task
                    self.realm.add(todoItem)
                })
            })
        }
        
    }
}
