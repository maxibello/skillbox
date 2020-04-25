//
//  StaticImagesViewController.swift
//  skillbox_8
//
//  Created by Максим Кузнецов on 19.04.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class StaticImagesViewController: UIViewController {

    let data: [InfoBlock] = [
        InfoBlock(photo: "sky.jpg", text: "Sky"),
        InfoBlock(photo: "river.jpg", text: "River"),
        InfoBlock(photo: "night.jpeg", text: "Night"),
        InfoBlock(photo: "moon.jpeg", text: "Moon")
    ]
    var viewBlocks: [(image: UIImageView, label: UILabel)] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        applyConstraints()
    }
    
    private func initUI() {
        for block in data {
            let image = UIImageView(image: UIImage(named: block.photo))
            let label = UILabel()
            label.text = block.text
            label.textAlignment = .center
            viewBlocks.append((image, label))
            
            view.addSubview(image)
            view.addSubview(label)
            
            image.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func applyConstraints() {
        let margins = view.safeAreaLayoutGuide
        let imageViewsConstaints = [
            viewBlocks[0].image.topAnchor.constraint(equalTo: margins.topAnchor),
            viewBlocks[0].image.leftAnchor.constraint(equalTo: margins.leftAnchor),
            viewBlocks[0].image.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            viewBlocks[0].image.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.4),
            viewBlocks[1].image.topAnchor.constraint(equalTo: margins.topAnchor),
            viewBlocks[1].image.rightAnchor.constraint(equalTo: margins.rightAnchor),
            viewBlocks[1].image.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            viewBlocks[1].image.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.4),
            viewBlocks[2].image.topAnchor.constraint(equalTo: viewBlocks[0].label.bottomAnchor),
            viewBlocks[2].image.leftAnchor.constraint(equalTo: margins.leftAnchor),
            viewBlocks[2].image.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            viewBlocks[2].image.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.4),
            viewBlocks[3].image.topAnchor.constraint(equalTo: viewBlocks[1].label.bottomAnchor),
            viewBlocks[3].image.rightAnchor.constraint(equalTo: margins.rightAnchor),
            viewBlocks[3].image.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            viewBlocks[3].image.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.4)
        ]
        let labelsConstraints = [
            viewBlocks[0].label.topAnchor.constraint(equalTo: viewBlocks[0].image.bottomAnchor),
            viewBlocks[0].label.leftAnchor.constraint(equalTo: margins.leftAnchor),
            viewBlocks[0].label.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            viewBlocks[0].label.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.1),
            viewBlocks[1].label.topAnchor.constraint(equalTo: viewBlocks[1].image.bottomAnchor),
            viewBlocks[1].label.rightAnchor.constraint(equalTo: margins.rightAnchor),
            viewBlocks[1].label.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            viewBlocks[1].label.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.1),
            viewBlocks[2].label.topAnchor.constraint(equalTo: viewBlocks[2].image.bottomAnchor),
            viewBlocks[2].label.leftAnchor.constraint(equalTo: margins.leftAnchor),
            viewBlocks[2].label.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            viewBlocks[2].label.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.1),
            viewBlocks[3].label.topAnchor.constraint(equalTo: viewBlocks[3].image.bottomAnchor),
            viewBlocks[3].label.rightAnchor.constraint(equalTo: margins.rightAnchor),
            viewBlocks[3].label.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5),
            viewBlocks[3].label.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.1),
        ]
        NSLayoutConstraint.activate(imageViewsConstaints + labelsConstraints)
    }
}
