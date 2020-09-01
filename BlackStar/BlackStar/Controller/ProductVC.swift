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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    
    @IBAction func addToCart(_ sender: Any) {
        
        guard children.count == 0,
            let sizePickerVC = self.storyboard?.instantiateViewController(withIdentifier: "SizePickerVC") as? SizePickerVC, let product = product else {
                return
        }
        addToCartButton.isEnabled = false
        addChild(sizePickerVC)
        
        sizePickerVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.isUserInteractionEnabled = true
        containerView.addSubview(sizePickerVC.view)
        NSLayoutConstraint.activate([
            sizePickerVC.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            sizePickerVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            sizePickerVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            sizePickerVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        sizePickerVC.didMove(toParent: self)
        
        sizePickerVC.delegate = self
        sizePickerVC.offers = product.offers.map { $0 }
    }
    
    let photoScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let photoPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0, green: 0.784, blue: 0.325, alpha: 1)
        return pageControl
    }()
    
    let backButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "backButton")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let basketControl: BasketControl = {
        let basketControl = BasketControl()
        basketControl.translatesAutoresizingMaskIntoConstraints = false
        return basketControl
    }()
    
    @objc func handleTap() {
        if children.count > 0 {
            closeSizePickerVC()
        }
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let product = product else { return }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        
        let backButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
//        backButtonRecognizer.delegate = self
        backButton.addGestureRecognizer(backButtonRecognizer)
        
        
        containerView.isUserInteractionEnabled = false
        photoScrollView.addSubview(photoPageControl)
        photoScrollView.addSubview(backButton)
        photoScrollView.addSubview(basketControl)
        //        photoPageControl.frame = CGRect(x: photoScrollView.bounds.size.width/2, y: photoScrollView.bounds.size.height / 2, width: photoPageControl.bounds.size.width, height: photoPageControl.bounds.size.height)
        view.addSubview(photoScrollView)
        
        
        
        setupConstraints()
        
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
                self.setupImages(self.loadedImages)
                self.photoScrollView.bringSubviewToFront(self.photoPageControl)
                self.photoScrollView.bringSubviewToFront(self.backButton)
                self.photoScrollView.bringSubviewToFront(self.basketControl)
                self.photoPageControl.numberOfPages = self.loadedImages.count
                self.photoPageControl.currentPage = 0
            }
        }
        updateUI(with: product)
        
    }
    
    private func setupConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoScrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            photoScrollView.heightAnchor.constraint(equalTo: photoScrollView.widthAnchor, multiplier: 0.8),
            nameLabel.topAnchor.constraint(equalTo: photoScrollView.bottomAnchor, constant: 8),
            photoPageControl.centerXAnchor.constraint(equalTo: photoScrollView.frameLayoutGuide.centerXAnchor),
            photoPageControl.bottomAnchor.constraint(equalTo: photoScrollView.frameLayoutGuide.bottomAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.topAnchor.constraint(equalTo: photoScrollView.frameLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: photoScrollView.frameLayoutGuide.leadingAnchor, constant: 10),
            basketControl.widthAnchor.constraint(equalToConstant: 32),
            basketControl.heightAnchor.constraint(equalToConstant: 32),
            basketControl.topAnchor.constraint(equalTo: photoScrollView.frameLayoutGuide.topAnchor, constant: 10),
            basketControl.trailingAnchor.constraint(equalTo: photoScrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            
        ])
    }
    
    private func setupImages(_ images: [UIImage]) {
        
        for i in 0..<images.count {
            
            let imageView = UIImageView()
            imageView.image = images[i]
            let xPosition = UIScreen.main.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: photoScrollView.frame.width, height: photoScrollView.frame.height)
            imageView.contentMode = .scaleAspectFill
            
            photoScrollView.contentSize.width = photoScrollView.frame.width * CGFloat(i + 1)
            photoScrollView.addSubview(imageView)
            photoScrollView.delegate = self
        }
        
    }
    
    private func updateUI(with product: FormedProduct) {
        nameLabel.text = product.frontProduct.name
        priceLabel.text = product.frontProduct.price.formattedPrice
        descriptionLabel.text = product.frontProduct.description
        descriptionLabel.sizeToFit()
    }
    
    private func closeSizePickerVC() {
        addToCartButton.isEnabled = true
        containerView.isUserInteractionEnabled = false
        let sizePickerVC = children[0]
        sizePickerVC.willMove(toParent: nil)
        //            childVCStackView.removeArrangedSubview(childVC.view)
        
        UIView.animate(withDuration: 0.8, animations: { sizePickerVC.view.alpha = 0 },
        completion: {(value: Bool) in
                      sizePickerVC.view.removeFromSuperview()
                    })
        
        sizePickerVC.removeFromParent()
    }
}

extension ProductVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        photoPageControl.currentPage = Int((scrollView.contentOffset.x + (0.5 * scrollView.frame.size.width))  / scrollView.frame.width)
    }
}

extension ProductVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: view)
        if location.y >= containerView.frame.origin.y {
            return false
        }
        return true
    }
}

extension ProductVC: SizePickerDelegate {
    func didPickSize(_: SizePickerVC) {
        closeSizePickerVC()
        basketControl.setShopItemsCount(with: basketControl.shopItemsCount + 1)
    }
    
    
}
