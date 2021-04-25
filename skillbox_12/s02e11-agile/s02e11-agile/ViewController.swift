//
//  ViewController.swift
//  s02e11-agile
//
//  Created by Maxim Kuznetsov on 24.04.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let model = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enterButton.isEnabled = false
        
        emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        enterButton.isEnabled = !(emailTextField.text?.isEmpty ?? true) && !(passwordTextField.text?.isEmpty ?? true)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        errorLabel.text = ""
        do {
            guard let email = emailTextField.text, let password = passwordTextField.text else { return }
            try model.checkEmail(email)
            try model.checkPassword(password)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "success")
            navigationController?.pushViewController(vc, animated: true)
        }
        
        catch ValidationError.emailError(let text) {
            errorLabel.text = text
        }
        catch ValidationError.passwordError(let text) {
            errorLabel.text = text
        }
        catch {
            errorLabel.text = "Произошла ошибка"
        }
    }
}

