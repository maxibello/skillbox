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
    var persistent: UserDefaultsPersistent? {
        guard let persistent = ServiceLocator.shared.get(UserDefaultsPersistent.self) else {
            return nil
        }
        return persistent
    }
    
    
    var persistentContainer: NSPersistentContainer? {
        guard let persistentContainer = ServiceLocator.shared.get(NSPersistentContainer.self) else {
            let errorVC = ErrorOverlayVC()
            errorVC.modalPresentationStyle = .overCurrentContext
            errorVC.modalTransitionStyle = .coverVertical
            errorVC.delegate = self
            errorVC.errorMessage = "CoreData storage initialization error"
            present(errorVC, animated: true, completion: nil)
            return nil
        }
        return persistentContainer
    }
    
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
            
            persistentContainer?.viewContext.delete(itemToDelete)
            saveContext()
            itemsToDo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func addNewTask(_ sender: Any) {
        let alert = UIAlertController(title: "New task", message: "Type what you want to do", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] action in
            guard let self = self, let textField = alert?.textFields?.first, let persistentContainer = self.persistentContainer else {
                return
            }
            
            if let text = textField.text, text.count > 0 {
                let todoItem = TodoItems(context: persistentContainer.viewContext)
                todoItem.text = text
                self.saveContext()
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
        guard let managedContext = persistentContainer?.viewContext else {
            return
        }
        let fetchRequest: NSFetchRequest<TodoItems> = TodoItems.fetchRequest()
        do {
            itemsToDo = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            showError(message: error.localizedDescription)
        }
    }
    
    private func populateDefaultTodosIfNeeded() {
        guard let persistentContainer = persistentContainer, let persistent = persistent, persistent.coreDataFirstLaunch == nil else {
            return
        }
        
        ["Clean my room", "Wash the dishes", "Save the planet"].forEach({ task in
            let todoItem = TodoItems(context: persistentContainer.viewContext)
            todoItem.text = task
            saveContext()
        })
        retrieveItems()
        persistent.coreDataFirstLaunch = true
        
    }
    
    private func saveContext() {
        guard let context = persistentContainer?.viewContext, context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            showError(message: error.localizedDescription)
        }
    }
}

extension ToDoListCoreDataViewController: ErrorOverlayDismissing {
    func didCloseErrorVC(_: ErrorOverlayVC) {
        dismiss(animated: true, completion: nil)
    }
}
