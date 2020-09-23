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
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!
    let disposeBag = DisposeBag()
    var elements = BehaviorSubject<[String]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myObservable = PublishSubject<Int>()
        
        incrementButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                myObservable.onNext(1)
                if let oldValues = try? self.elements.value() {
                    self.elements.onNext(oldValues + ["+"])
                }
            })
            .disposed(by: disposeBag)
        
        decrementButton.rx.tap
            .subscribe(onNext: {
                myObservable.onNext(-1)
                if let oldValues = try? self.elements.value() {
                    self.elements.onNext(oldValues + ["-"])
                }
            })
            .disposed(by: disposeBag)
        
        myObservable
            .delay(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] value in
                self.updateLabel(with: value)
                if let oldValues = try? self.elements.value() {
                    self.elements.onNext(oldValues.dropLast())
                }
            })
            .disposed(by: disposeBag)
        
        elements
            .map({
                if $0.count > 0 {
                    return "Сейчас в очереди \($0.count) операции: " + $0.joined(separator: ",")
                } else {
                    return "Очередь пуста, значение лейбла: \(Int(self.counterLabel.text ?? "") ?? 0)"
                }
            })
            .bind(to: debugLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func updateLabel(with value: Int) {
        let currentValue = Int(counterLabel.text ?? "") ?? 0
        counterLabel.text = "\(currentValue + value)"
    }
}
