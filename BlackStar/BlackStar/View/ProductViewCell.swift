//
//  ProductViewCell.swift
//  BlackStar
//
//  Created by Максим on 28.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class ProductViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    func configure(with product: Product) {
        nameLabel.text = product.name
        priceLabel.text = product.price
        
        BlackStarApiService.downloadImage(from: product.mainImage) { [weak self] image, error in
            DispatchQueue.main.async {
                self?.photoImageView.image = image
//                self?.imageLoader.stopAnimating()
            }
        }
    }
}
