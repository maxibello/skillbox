//
//  BlurImageVC.swift
//  s02e05_concurrency
//
//  Created by Максим on 29.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class BlurImageVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    let imageURL = "https://garderobus.ru/wp-content/uploads/2019/02/post_5c66cd586ad01.jpeg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFill
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            if let url = URL(string: self.imageURL),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                    let blurEffect = UIBlurEffect(style: .regular)
                    let blurredEffectView = UIVisualEffectView(effect: blurEffect)
                    blurredEffectView.frame = self.imageView.frame
                    self.view.addSubview(blurredEffectView)
                }
            }
        }
        
    }
}
