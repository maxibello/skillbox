//
//  ViewController+showError.swift
//  skillbox_14
//
//  Created by Максим Кузнецов on 28.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

