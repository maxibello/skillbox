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
        photoImageView.image = nil
        [photoImageView, nameLabel, speciesLabel, idLabel].forEach { $0.isHidden = true }
        
        activityIndicator.startAnimating()
        imageViewLoader.startAnimating()
    }
    
    func configure(with model: Character) {
        
        backgroundColor = UIColor(red: 249/255, green: 214/255, blue: 1, alpha: 1)
        nameLabel.text = model.name
        speciesLabel.text = "Species: \(model.species)"
        idLabel.text = "#\(model.id)"
        
        DispatchQueue.main.async { [weak self] in
            if let localImage = model.localImage {
                self?.photoImageView.image = localImage
                self?.imageViewLoader.stopAnimating()
            } else {
                self?.downloadImageFromRemote(with: model)
            }
            self?.finishModifying()
        }
        
    }
    

    func downloadImageFromRemote(with model: Character) {
        if let imageURL = URL(string: model.image) {
            //            imageViewLoader.startAnimating()
                        RickMortyApiService.downloadImage(url: imageURL) { [weak self] image, error in
                            DispatchQueue.main.async {
                                guard let self = self, let image = image else { return }
                                
                                model.tempImage = image
                                if model.localImage == nil {
                                    model.saveLocalImage(image)
                                }
                                self.photoImageView.image = image
                                self.imageViewLoader.stopAnimating()
                            }
                        }
                    }
        }
    
    
    private func finishModifying() {
        [photoImageView, nameLabel, speciesLabel, idLabel].forEach { $0.isHidden = false }
        activityIndicator.stopAnimating()
    }
}
