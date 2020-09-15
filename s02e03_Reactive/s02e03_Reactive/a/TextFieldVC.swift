//
//  ViewController.swift
//  s02e03_Reactive
//
//  Created by Максим on 13.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TextFieldVC: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let loginValid = loginTextField
            .rx
            .text.orEmpty
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .map { [unowned self] in
                self.validate(login: $0)
        }
        
        loginValid
            .subscribe(onNext: { [unowned self] result in
                if !result, let currentText = self.loginTextField.text, !currentText.isEmpty {
                    self.messageLabel.text = "Некорректная почта"
                } else {
                    self.messageLabel.text = ""
                }
            })
            .disposed(by: disposeBag)
        
        let passwordValid = passwordTextField
            .rx
            .text.orEmpty
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .map { [unowned self] in
                self.validate(password: $0)
        }
        
        passwordValid
            .subscribe(onNext: { [unowned self] result in
                if !result, let currentText = self.passwordTextField.text, !currentText.isEmpty {
                    self.messageLabel.text = "Слишком короткий пароль"
                } else {
                    self.messageLabel.text = ""
                }
            })
            .disposed(by: disposeBag)
        
        let everythingValid = Observable<Bool>.combineLatest(loginValid, passwordValid) { $0 && $1
        }

        everythingValid
          .bind(to: sendButton.rx.isEnabled)
          .disposed(by: disposeBag)
    }
    
    func validate(login: String?) -> Bool {
        guard let login = login else { return false }
        print(login)
        let regex = try! NSRegularExpression(pattern: "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .caseInsensitive)
        return regex.firstMatch(in: login, options: [], range: NSRange(location: 0, length: login.count)) != nil
    }
    
    func validate(password: String) -> Bool {
        return password.count >= 6
    }
    
}
