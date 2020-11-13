//
//  SecondViewController.swift
//  s02e06_instruments
//
//  Created by Maxim Kuznetsov on 01.11.2020.
//

import UIKit

class ClosureViewController: UIViewController {
    
    private var counter = 0
    private var closure : (() -> ()) = { }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        closure = {
                    self.counter += 1
                    print(self.counter)
                }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print("SecondViewController deinit")
    }
}
