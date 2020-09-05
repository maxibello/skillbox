//
//  ColorOffersViewCell.swift
//  BlackStar
//
//  Created by Максим on 30.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class ColorOffersViewCell: UITableViewCell {
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var colorImageView: UIImageView!
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    
    func configure(with offer: Offer, colorURL: String) {
        sizeLabel.text = offer.size
        colorImageView.layer.cornerRadius = colorImageView.bounds.width / 2
        colorImageView.layer.borderColor = UIColor.black.cgColor
        colorImageView.layer.borderWidth = 1
        colorImageView.clipsToBounds = true
        
        BlackStarApiService.downloadImage(from: colorURL) { [weak self] image, error in
            DispatchQueue.main.async {
                self?.colorImageView.image = image
                self?.imageLoader.stopAnimating()
            }
        }
    }
}

