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
    
    let delayIntervalMilliseconds = 500
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestField = textField
            .rx
            .text.orEmpty
            .filter({ !$0.isEmpty })
            .debounce(.milliseconds(delayIntervalMilliseconds), scheduler: MainScheduler.instance)
        
        requestField
            .subscribe(onNext: {
                print("Отправка запроса для \($0)")
            })
            .disposed(by: disposeBag)
    }
}
