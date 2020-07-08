//
//  CharacterViewCell.swift
//  skillbox_12.1
//
//  Created by Максим Кузнецов on 07.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class CharacterViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var imageViewLoader: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
      super.prepareForReuse()
      configure(with: .none)
    }
    
    func configure(with model: Character?) {
        if let model = model {
            backgroundColor = UIColor(red: 249/255, green: 214/255, blue: 1, alpha: 1)
            nameLabel.text = model.name
            speciesLabel.text = "Species: \(model.species)"
            idLabel.text = "#\(model.id)"
            
            if let imageURL = URL(string: model.image) {
                HTTPService.downloadImage(url: imageURL) { [weak self] image, error in
                    DispatchQueue.main.async {
                        self?.photoImageView.image = image
                        self?.imageViewLoader.stopAnimating()
                    }
                }
            }
            photoImageView.alpha = 1
            nameLabel.alpha = 1
            speciesLabel.alpha = 1
            idLabel.alpha = 1
            activityIndicator.stopAnimating()
        } else {
            photoImageView.image = nil
            photoImageView.alpha = 0
            nameLabel.alpha = 0
            speciesLabel.alpha = 0
            idLabel.alpha = 0
            
            activityIndicator.startAnimating()
            imageViewLoader.startAnimating()
        }
        
    }
}
