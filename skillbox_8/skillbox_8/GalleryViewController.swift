//
//  ViewController.swift
//  skillbox_8
//
//  Created by Максим Кузнецов on 19.04.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let photos: [UIImage?] = [
        UIImage(named: "volvo.jpg"),
        UIImage(named: "diablo.jpg"),
        UIImage(named: "viper.jpg"),
        UIImage(named: "f40.jpg"),
        UIImage(named: "jaga.jpg"),
        UIImage(named: "chev.jpg"),
        UIImage(named: "lotus.jpg"),
        UIImage(named: "honda.jpg"),
        UIImage(named: "lotus.jpg"),
        UIImage(named: "huracan.jpg")
    ]
    
    var currentPhoto: UIImage? {
        didSet {
            imageView.image = currentPhoto
        }
    }
    
    var currentIndex: Int = 0 {
        didSet {
            currentPhoto = photos[currentIndex]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currentPhoto = photos[0]
    }
    
    @IBAction func nextPhoto(_ sender: Any) {
        if currentIndex >= photos.count - 1 {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
    }
    
    @IBAction func prevPhoto(_ sender: Any) {
        if currentIndex <= 0 {
            currentIndex = photos.count - 1
        } else {
            currentIndex -= 1
        }
    }
}

