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
    
    var persistent: UserDefaultsPersistent? {
        guard let persistent = ServiceLocator.shared.get(UserDefaultsPersistent.self) else {
            let errorVC = ErrorOverlayVC()
            errorVC.modalPresentationStyle = .overCurrentContext
            errorVC.modalTransitionStyle = .coverVertical
            errorVC.delegate = self
            errorVC.errorMessage = "UserDefaults initialization error"
            present(errorVC, animated: true, completion: nil)
            return nil
        }
        return persistent
    }
    var fetchedResultsController: NSFetchedResultsController<TodoItems>!
    
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
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell")!
        cell.textLabel?.text = fetchedResultsController.object(at: indexPath).text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let itemToDelete = fetchedResultsController.object(at: indexPath)
        
        persistentContainer?.viewContext.delete(itemToDelete)
        saveContext()
    }
    
    @IBAction func addNewTask(_ sender: Any) {
        let alert = UIAlertController(title: "New task", message: "Type what you want to do", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] action in
            guard let self = self, let textField = alert?.textFields?.first, let persistentContainer = self.persistentContainer else {
                return
            }
            
            guard let text = textField.text, text.count > 0 else { return }
            
            let todoItem = TodoItems(context: persistentContainer.viewContext)
            todoItem.text = text
            self.saveContext()
            self.retrieveItems()
            self.tableView.reloadData()
            
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
        
        if fetchedResultsController == nil {
            let request: NSFetchRequest<TodoItems> = TodoItems.fetchRequest()
            let sort = NSSortDescriptor(key: "text", ascending: true)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20

            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
        }

        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            showError(message: "Fetch failed")
        }
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

extension ToDoListCoreDataViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)

        default:
            break
        }
    }
}
