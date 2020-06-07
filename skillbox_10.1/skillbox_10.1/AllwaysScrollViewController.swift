//
//  File.swift
//  skillbox_10.1
//
//  Created by Максим Кузнецов on 30.05.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class AllwaysScrollViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = UIScrollView(frame: view.bounds)
        sv.backgroundColor = .lightGray
        sv.contentSize = CGSize(width: view.bounds.width * 2, height: view.bounds.height * 2)
        
        let motionlessView = UIView(frame: CGRect(x: 50, y: 50, width: 150, height: 80))
        motionlessView.backgroundColor = .yellow
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.bounds.width * 2, height: view.bounds.height * 2))
        imageView.image = UIImage(named: "gates")
        imageView.contentMode = .scaleAspectFill
        
        view.addSubview(sv)
        view.addSubview(motionlessView)
        sv.addSubview(imageView)
        
    }
}
