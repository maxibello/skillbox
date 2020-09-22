//
//  RocketVC.swift
//  s02e03_Reactive
//
//  Created by Максим on 15.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit
import RxSwift

class RocketVC: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let launchRocket = Observable<Bool>.combineLatest(
            firstButton.rx.tap.map({ true }),
            secondButton.rx.tap.map({ true })) { $0 && $1 }
            .distinctUntilChanged()
        
        launchRocket
            .subscribe(onNext: { [unowned self] in
                if $0 {
                    self.mainLabel.text = "Ракета запущена"
                }
            })
            .disposed(by: disposeBag)
    }
    
}
