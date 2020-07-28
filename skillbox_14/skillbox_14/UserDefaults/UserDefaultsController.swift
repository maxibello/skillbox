//
//  ViewController.swift
//  skillbox_14
//
//  Created by Максим Кузнецов on 12.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class UserDefaultsController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    
    let persistent = UserDefaultsPersistent.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstnameTextField.text = persistent.firstname
        lastnameTextField.text = persistent.lastname
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
           let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if textField === firstnameTextField {
                persistent.firstname = updatedText
            } else if textField === lastnameTextField {
                persistent.lastname = updatedText
            }
        }
        
        return true
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }

}

