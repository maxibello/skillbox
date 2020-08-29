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
    
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        [nameLabel, priceLabel].forEach({ $0?.isHidden = true })
        imageLoader.startAnimating()
    }
    
    func configure(with product: Product) {
        nameLabel.text = product.name
        nameLabel.textColor = UIColor(red: 0.459, green: 0.459, blue: 0.459, alpha: 1)
        nameLabel.font = UIFont(name: "SFProDisplay-Medium", size: 11)
        
        priceLabel.text = product.price.formattedPrice
        priceLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        priceLabel.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        
        BlackStarApiService.downloadImage(from: product.mainImage) { [weak self] image, error in
            DispatchQueue.main.async {
                self?.photoImageView.image = image
                self?.imageLoader.stopAnimating()
//                self?.imageLoader.stopAnimating()
            }
        }
    }
}
