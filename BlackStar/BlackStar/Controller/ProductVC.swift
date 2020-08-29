//
//  ProductVC.swift
//  BlackStar
//
//  Created by Максим on 29.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class ProductVC: UIViewController {
    var product: FormedProduct?
    var loadedImages: [UIImage] = []
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBAction func addToCart(_ sender: Any) {
    }
    @IBOutlet weak var photoPageControl: UIPageControl!
    
    
    @IBAction func photoChanged(_ sender: Any) {
        productImageView.image = loadedImages[photoPageControl.currentPage]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let product = product else { return }
        

        DispatchQueue.global(qos: .userInitiated).async {
            let downloadGroup = DispatchGroup()
            for photo in product.photoGallery {
                downloadGroup.enter()
                BlackStarApiService.downloadImage(from: photo.imageURL) { [weak self] image, error in
                    if let image = image {
                        self?.loadedImages.append(image)
                    }
                    downloadGroup.leave()
                        }
                
            }
            downloadGroup.wait()
            DispatchQueue.main.async {
                self.productImageView.image = self.loadedImages.first
                
                if self.loadedImages.count > 1 {
                    self.photoPageControl.numberOfPages = self.loadedImages.count
                    self.photoPageControl.currentPage = 0
                    self.photoPageControl.isHidden = false
                    
                }
            }
        }
                updateUI(with: product)
        
    }
    
    private func updateUI(with product: FormedProduct) {
        
        
//        productImageView.image = product.photoGallery.first?.
        nameLabel.text = product.frontProduct.name
        priceLabel.text = product.frontProduct.price.formattedPrice
        descriptionLabel.text = product.frontProduct.description
        
    }
}
