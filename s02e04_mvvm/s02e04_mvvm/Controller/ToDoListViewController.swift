//
//  ToDoListViewController.swift
//  skillbox_14
//
//  Created by Максим Кузнецов on 14.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class ToDoListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ToDoListViewModel()
    let disposeBag = DisposeBag()
    
    let persistent = UserDefaultsPersistent.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        
        viewModel
            .items
            .bind(to: tableView.rx.items(cellIdentifier: "ToDoCell")) { _, item, cell in
                cell.textLabel?.text = item.text
        }
            
        .disposed(by: disposeBag)
        
        tableView.rx.modelDeleted(ToDoItem.self)
            .subscribe(onNext: { [unowned self] item in
                self.viewModel.delete(item)
                    .subscribe(onError: { error in
                        let errorVC = ErrorOverlayVC()
                        errorVC.modalPresentationStyle = .overCurrentContext
                        errorVC.modalTransitionStyle = .coverVertical
                        errorVC.delegate = self
                        errorVC.errorMessage = error.localizedDescription
                        self.present(errorVC, animated: true, completion: nil)
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func addTask(_ sender: Any) {
        
        let alert = UIAlertController(title: "New task", message: "Type what you want to do", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] action in
            guard let self = self, let textField = alert?.textFields?.first else {
                return
            }
            if let text = textField.text, text.count > 0 {
                self.viewModel.save(text)
                    .subscribe(onError: { error in
                        let errorVC = ErrorOverlayVC()
                        errorVC.modalPresentationStyle = .overCurrentContext
                        errorVC.modalTransitionStyle = .coverVertical
                        errorVC.delegate = self
                        errorVC.errorMessage = error.localizedDescription
                        self.present(errorVC, animated: true, completion: nil)
                    })
                    .disposed(by: self.disposeBag)
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
