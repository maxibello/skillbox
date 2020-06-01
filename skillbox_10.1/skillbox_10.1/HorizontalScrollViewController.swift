//
//  ViewController.swift
//  skillbox_10.1
//
//  Created by Максим Кузнецов on 30.05.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class HorizontalScrollViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView(frame: view.bounds)
        sv.backgroundColor = .lightGray
        sv.contentSize = CGSize(width: view.bounds.width * 2, height: view.bounds.height)
        
        view.addSubview(sv)
    }

}

