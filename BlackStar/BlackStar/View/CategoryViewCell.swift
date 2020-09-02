//
//  CategoryViewCell.swift
//  BlackStar
//
//  Created by Максим on 27.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class CategoryViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoader.startAnimating()
    }
    
    func configure(with category: Category) {
        categoryLabel.text = category.name
        
        
        BlackStarApiService.downloadImage(from: category.iconImage) { [weak self] image, error in
            DispatchQueue.main.async {
                self?.categoryImageView.image = image
                self?.imageLoader.stopAnimating()
            }
        }
    }
}
