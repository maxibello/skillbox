//
//  SubcategoryViewCell.swift
//  BlackStar
//
//  Created by Максим on 27.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class SubcategoryViewCell: UITableViewCell {
    
    @IBOutlet weak var subcategoryImageView: UIImageView!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subcategoryImageView.image = nil
        imageLoader.startAnimating()
    }
    
    func configure(with subcategory: Subcategory) {
        subcategoryLabel.text = subcategory.name
        imageLoader.startAnimating()
        
        guard !subcategory.iconImage.isEmpty else {
            imageLoader.stopAnimating()
            return
        }
        
        BlackStarApiService.downloadImage(from: subcategory.iconImage) { [weak self] image, error in
            DispatchQueue.main.async {
                self?.subcategoryImageView.image = image
                self?.imageLoader.stopAnimating()
            }
        }
    }
}
