//
//  CartAlertVC.swift
//  BlackStar
//
//  Created by Максим on 03.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class CartAlertVC: UIViewController {
    
    var okAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    @IBOutlet weak var contentView: CartAlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.layer.cornerRadius = 8
    }
    
    @IBAction func okButton(_ sender: Any) {
        if let okAction = okAction {
            okAction()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        if let cancelAction = cancelAction {
            cancelAction()
        }
        dismiss(animated: true, completion: nil)
    }
}
