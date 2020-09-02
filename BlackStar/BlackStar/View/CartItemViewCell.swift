//
//  CartItemViewCell.swift
//  BlackStar
//
//  Created by Максим on 01.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class CartItemViewCell: UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    func configure(with item: CartItem) {
        guard let offer = item.offer else { return }

        nameLabel.text = item.name
        sizeLabel.text = "Размер: \(offer.size)"
        colorLabel.text = "Цвет: \(item.color)"
        priceLabel.text = item.price.formattedPrice
        if let image = item.localImage {
            photoImageView.image = image
        }
    }
    
}
