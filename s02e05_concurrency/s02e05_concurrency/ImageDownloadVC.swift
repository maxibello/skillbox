//
//  ViewController.swift
//  s02e05_concurrency
//
//  Created by Максим on 29.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class ImageDownloadVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    let imageURL = "https://garderobus.ru/wp-content/uploads/2019/02/post_5c66cd586ad01.jpeg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFill
        
        guard let url = URL(string: imageURL) else { return }
        
        URLSession.shared.dataTask(with: url) {
          [weak self] data, _, _ in
          guard let self = self,
            let data = data,
            let image = UIImage(data: data) else {
              return
          }
          DispatchQueue.main.async {
            self.imageView.image = image
          }
        }.resume()
    }


}

