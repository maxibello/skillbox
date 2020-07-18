//
//  ToDoListCoreDataViewController.swift
//  skillbox_14
//
//  Created by Максим Кузнецов on 16.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit
import CoreData

class ToDoListCoreDataViewController: UITableViewController {
    
    var itemsToDo: [TodoItems] = []
    let coreDataStack = CoreDataStack(modelName: "skillbox_14")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveItems()
        populateDefaultTodosIfNeeded()
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
            let itemToDelete = itemsToDo[indexPath.row]
            coreDataStack.managedContext.delete(itemToDelete)
            coreDataStack.saveContext()
            itemsToDo.remove(at: indexPath.row)
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
                let todoItem = TodoItems(context: self.coreDataStack.managedContext)
                todoItem.text = text
                self.coreDataStack.saveContext()
                self.retrieveItems()
                self.tableView.reloadData()
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func retrieveItems() {
        let managedContext =
        coreDataStack.managedContext
        let fetchRequest: NSFetchRequest<TodoItems> = TodoItems.fetchRequest()
        do {
            itemsToDo = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func populateDefaultTodosIfNeeded() {
        if itemsToDo.count == 0 {
            ["Clean my room", "Wash the dishes", "Save the planet"].forEach({ task in
                let todoItem = TodoItems(context: coreDataStack.managedContext)
                todoItem.text = task
                coreDataStack.saveContext()
            })
            retrieveItems()
        }
        
    }
}
