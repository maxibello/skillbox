//
//  TableVC.swift
//  s02e03_Reactive
//
//  Created by Максим on 14.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit
import RxSwift

class TableVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var items = BehaviorSubject<[String]>(value: [])
    private let disposeBag = DisposeBag()
    
    let names = ["Халдир", "Арвен", "Элронд",
                 "Тауриэль", "Леголас", "Трандуил",
                 "Келеборн", "Фигвит", "Линдир"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items
          .bind(to: tableView
            .rx
            .items(cellIdentifier: NameCell.identifier,
                   cellType: NameCell.self)) {
                    row, item, cell in
                    cell.configure(with: item)
          }
          .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(onNext: { [unowned self] in
                if let randomName = self.names.randomElement(),
                    let currentItems = try? self.items.value() {
                    let newItems = currentItems + [randomName]
                    self.items.onNext(newItems)
                }
            })
        .disposed(by: disposeBag)
        
        deleteButton.rx.tap
        .bind(onNext: { [unowned self] in
            if let currentItems = try? self.items.value() {
                self.items.onNext(currentItems.dropLast())
            }
        })
        .disposed(by: disposeBag)
        
    }
    
}
