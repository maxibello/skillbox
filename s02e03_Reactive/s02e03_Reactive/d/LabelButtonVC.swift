//
//  LabelButtonVC.swift
//  s02e03_Reactive
//
//  Created by Максим on 14.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LabelButtonVC: UIViewController {
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incrementButton.rx.tap
        .subscribe(onNext: { [unowned self] in
            self.counterLabel.text = "\((Int(self.counterLabel.text ?? "") ?? 0) + 1)"
        })
        .disposed(by: disposeBag)
    }
}
