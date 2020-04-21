//
//  StaticImagesViewController.swift
//  skillbox_8
//
//  Created by Максим Кузнецов on 19.04.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class StaticImagesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView1 = UIImageView(image: UIImage(named: "sky.jpg"))
        imageView1.contentMode = .scaleAspectFit
        let label1 = UILabel()
        label1.text = "Sky"
        label1.textAlignment = .center
        
        let imageView2 = UIImageView(image: UIImage(named: "river.jpg"))
        imageView2.contentMode = .scaleAspectFit
        let label2 = UILabel()
        label2.text = "River"
        label2.textAlignment = .center

        let imageView3 = UIImageView(image: UIImage(named: "night.jpeg"))
        imageView3.contentMode = .scaleAspectFit
        let label3 = UILabel()
        label3.text = "Night"
        label3.textAlignment = .center

        let imageView4 = UIImageView(image: UIImage(named: "moon.jpeg"))
        imageView4.contentMode = .scaleAspectFit
        let label4 = UILabel()
        label4.text = "Moon"
        label4.textAlignment = .center
        
        view.addSubview(imageView1)
        view.addSubview(imageView2)
        view.addSubview(imageView3)
        view.addSubview(imageView4)
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        
        let margins = view.safeAreaLayoutGuide
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        imageView4.translatesAutoresizingMaskIntoConstraints = false
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        label4.translatesAutoresizingMaskIntoConstraints = false
        
        let imageViewsConstaints = [
            imageView1.topAnchor.constraint(equalTo: margins.topAnchor),
            imageView1.leftAnchor.constraint(equalTo: margins.leftAnchor),
            imageView1.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            imageView1.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.4),
            imageView2.topAnchor.constraint(equalTo: margins.topAnchor),
            imageView2.rightAnchor.constraint(equalTo: margins.rightAnchor),
            imageView2.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            imageView2.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.4),
            imageView3.topAnchor.constraint(equalTo: label1.bottomAnchor),
            imageView3.leftAnchor.constraint(equalTo: margins.leftAnchor),
            imageView3.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            imageView3.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.4),
            imageView4.topAnchor.constraint(equalTo: label2.bottomAnchor),
            imageView4.rightAnchor.constraint(equalTo: margins.rightAnchor),
            imageView4.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            imageView4.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.4)
        ]
        let labelsConstraints = [
            label1.topAnchor.constraint(equalTo: imageView1.bottomAnchor),
            label1.leftAnchor.constraint(equalTo: margins.leftAnchor),
            label1.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            label1.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.1),
            label2.topAnchor.constraint(equalTo: imageView2.bottomAnchor),
            label2.rightAnchor.constraint(equalTo: margins.rightAnchor),
            label2.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            label2.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.1),
            label3.topAnchor.constraint(equalTo: imageView3.bottomAnchor),
            label3.leftAnchor.constraint(equalTo: margins.leftAnchor),
            label3.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            label3.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.1),
            label4.topAnchor.constraint(equalTo: imageView4.bottomAnchor),
            label4.rightAnchor.constraint(equalTo: margins.rightAnchor),
            label4.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            label4.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.1),
        ]
        NSLayoutConstraint.activate(imageViewsConstaints + labelsConstraints)
    }
}
