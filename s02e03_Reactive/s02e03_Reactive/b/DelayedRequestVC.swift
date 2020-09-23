//
//  DelayedRequestVC.swift
//  s02e03_Reactive
//
//  Created by Максим on 14.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit
import RxSwift
//import RxCocoa

class DelayedRequestVC: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let delayIntervalMilliseconds = 500
    let disposeBag = DisposeBag()
    let filterSource = PublishSubject<String>()
    
    var items = BehaviorSubject<[String]>(value: [])
    private var workItem: DispatchWorkItem?
    
    var filteredItems: [String] = []
    let all = ["Кукусик", "Мумусик", "Ника Водвуд",
               "Никсель Пиксель", "Абьюз", "Виктимблейминг",
               "Менсплейнинг", "Мизогиния", "Бодипозитив",
               "Бодишейминг", "Харассмент"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestFieldFilter = textField
            .rx
            .text.orEmpty
            .filter({ !$0.isEmpty })
            .debounce(.milliseconds(delayIntervalMilliseconds), scheduler: MainScheduler.instance)
        
        let requestFieldEmpty = textField
            .rx
            .text.orEmpty
            .filter({ $0.isEmpty })
            .debounce(.milliseconds(delayIntervalMilliseconds), scheduler: MainScheduler.instance)

        
        requestFieldEmpty.subscribe(onNext: { [unowned self] _ in
            self.workItem?.cancel()
            self.items.onNext(self.all)
            self.activityIndicator.stopAnimating()
        })
            .disposed(by: disposeBag)
        
        
        
        requestFieldFilter
            .subscribe(onNext: { [unowned self] searchValue in
                self.activityIndicator.startAnimating()
                
                self.workItem?.cancel()
                self.workItem = DispatchWorkItem {
                    self.filteredItems = self.all.filter({ $0.lowercased().contains(searchValue.lowercased()) })
                    self.items.onNext(self.filteredItems)
                    self.activityIndicator.stopAnimating()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.workItem?.perform()
                })
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.delegate = nil
        tableView.dataSource = nil
        items
            .bind(to: tableView
                .rx
                .items(cellIdentifier: NameCell.identifier,
                       cellType: NameCell.self)) {
                        row, item, cell in
                        cell.configure(with: item)
        }
        .disposed(by: disposeBag)
    }
}
