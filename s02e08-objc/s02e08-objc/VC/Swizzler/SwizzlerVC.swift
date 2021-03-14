//
//  SwizzlerVC.swift
//  s02e08-objc
//
//  Created by Maxim Kuznetsov on 01.01.2021.
//

import UIKit

class SwizzlerVC: UIViewController {
    
    let presents = ["PlayStation 5", "Бенгальские огни", "Шоколадный заяц"]
    var yourGift: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let gift = yourGift {
            let alert = UIAlertController(title: "С Новым Годом!", message: "Дед Мороз положил под ёлку: \(gift)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Спасибо", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        performSegueWithIdentifier(identifier: "Swizzler1", sender: self, configurate: {[weak self] segue in
            if let targetVC = segue.destination as? SwizzlerVC {
                targetVC.yourGift = self?.presents.randomElement()
        }
    })
        }
}
