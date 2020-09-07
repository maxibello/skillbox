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
    
    let cartDBManager = CartDBManager.shared
    var delegate: ProductListVC?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    
    lazy var photoScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    lazy var imageLoader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        loader.style = .large
        loader.color = .lightGray
        return loader
    }()
    
    lazy var photoPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0, green: 0.784, blue: 0.325, alpha: 1)
        return pageControl
    }()
    
    lazy var backButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backButton")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var basketControl: BasketControl = {
        let basketControl = BasketControl()
        basketControl.translatesAutoresizingMaskIntoConstraints = false
        return basketControl
    }()
    
    lazy var blurView: UIView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.alpha = 0
        return blurEffectView
    }()
    
    lazy var hudImageView: UIImageView = {
        let hud = UIImageView(image: UIImage(named: "hud"))
        hud.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        hud.center = view.center
        return hud
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let product = product else { return }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        
        let backButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButton.addGestureRecognizer(backButtonRecognizer)
        
        let cartButtonRecognizer = UITapGestureRecognizer(target: self, action: #selector(cartButtonTapped))
        basketControl.addGestureRecognizer(cartButtonRecognizer)
        
        containerView.isUserInteractionEnabled = false
        photoScrollView.addSubview(photoPageControl)
        photoScrollView.addSubview(backButton)
        photoScrollView.addSubview(basketControl)
        photoScrollView.addSubview(imageLoader)
        view.addSubview(photoScrollView)
        view.addSubview(blurView)
        setupConstraints()
        
        
        imageLoader.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {
            let downloadGroup = DispatchGroup()
            for relativeUrl in Array(arrayLiteral: product.frontProduct.mainImage) + product.photoGallery.map({ $0.imageURL }) {
                downloadGroup.enter()
                BlackStarApiService.downloadImage(from: relativeUrl) { [weak self] image, error in
                    if let image = image {
                        self?.loadedImages.append(image)
                    }
                    downloadGroup.leave()
                }
                
            }
            downloadGroup.wait()
            DispatchQueue.main.async {
                self.imageLoader.stopAnimating()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        basketControl.setShopItemsCount(with: cartDBManager.getItemsCount())
    }
    
    @IBAction func addToCart(_ sender: Any) {
        
        guard children.count == 0,
            let sizePickerVC = self.storyboard?.instantiateViewController(withIdentifier: "SizePickerVC") as? SizePickerVC, let product = product else {
                return
        }
        showBlur()
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
        sizePickerVC.options = product.offers
    }

    @objc func handleTap() {
        if children.count > 0 {
            closeSizePickerVC()
            UIView.animate(withDuration: 0.3, animations: {
                self.blurView.alpha = 0
            })
        }
    }
    
    @objc func backButtonTapped() {
        delegate?.basketHelper.updateControl()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cartButtonTapped() {
        performSegue(withIdentifier: "CartItems", sender: self)
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
            imageLoader.centerXAnchor.constraint(equalTo: photoScrollView.frameLayoutGuide.centerXAnchor),
            imageLoader.centerYAnchor.constraint(equalTo: photoScrollView.frameLayoutGuide.centerYAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }
    
    private func setupImages(_ images: [UIImage]) {
        
        var imageViews: [UIImageView] = []
        for i in 0..<images.count {
            
            let imageView = UIImageView()
            imageViews.append(imageView)
            imageView.image = images[i]
            imageView.contentMode = .scaleAspectFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            photoScrollView.contentSize.width = photoScrollView.frame.width * CGFloat(i + 1)
            photoScrollView.addSubview(imageView)
            photoScrollView.delegate = self
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: photoScrollView.frameLayoutGuide.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: photoScrollView.frameLayoutGuide.heightAnchor)
            ])
        }
        
        guard imageViews.count > 0 else { return }
        imageViews[0].leadingAnchor.constraint(equalTo: photoScrollView.leadingAnchor).isActive = true
        
        for i in 1..<imageViews.count {
            imageViews[i].leadingAnchor.constraint(equalTo: imageViews[i - 1].trailingAnchor).isActive = true
        }
        
    }
    
    private func updateUI(with product: FormedProduct) {
        nameLabel.text = product.frontProduct.name.withoutHtml
        priceLabel.text = product.frontProduct.price.formattedPrice
        descriptionLabel.text = product.frontProduct.description.withoutHtml
    }
    
    private func performSuccessAnimation() {
        hudImageView.alpha = 0
        view.addSubview(hudImageView)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.hudImageView.alpha = 1
        }, completion: { result in
            UIView.animate(withDuration: 0.2, animations: {
                self.hudImageView.alpha = 0
            }, completion: { result in
                UIView.animate(withDuration: 0.3,
                               animations: {
                                self.blurView.alpha = 0
                },
                               completion: { result in
                                self.basketControl.setShopItemsCount(with: self.basketControl.shopItemsCount + 1, animated: true)
                }
                               )
            })
        })
    }
    
    private func showBlur() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.blurView.alpha = 1
        })
    }
    
    private func hideBlur() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.blurView.alpha = 0
        })
    }
        
    private func closeSizePickerVC() {
        addToCartButton.isEnabled = true
        containerView.isUserInteractionEnabled = false
        let sizePickerVC = children[0]
        sizePickerVC.willMove(toParent: nil)
        
        UIView.animate(withDuration: 0.3, animations: { sizePickerVC.view.alpha = 0 },
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
    func didPickSize(_: SizePickerVC, color: String, offer: Offer) {
        closeSizePickerVC()
        
        
        guard let product = product else { return }
        let cartItem = CartItem(from: product,
                                color: color,
                                offer: offer,
                                image: loadedImages.first
        )
        
        cartDBManager.add(cart: cartItem)
        performSuccessAnimation()
    }
}
