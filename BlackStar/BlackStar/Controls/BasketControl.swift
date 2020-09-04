//
//  BasketControl.swift
//  BlackStar
//
//  Created by Максим on 31.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class BasketControl: UIView {
    
    private (set) var shopItemsCount: Int = 0
    var bubbleWidthConstraint: NSLayoutConstraint?
    var bubbleHeightConstaint: NSLayoutConstraint?

    
    var cart: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "cart")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var itemsCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var bubbleView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "redCircle"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setShopItemsCount(with value: Int, animated: Bool = false) {
        shopItemsCount = value
        guard shopItemsCount > 0 else {
            bubbleView.isHidden = true
            return
        }
        
        bubbleView.isHidden = false
        
        itemsCountLabel.text = "\(shopItemsCount)"
        
        if animated {
            if let widthConstraint = bubbleWidthConstraint, let heightConstraint = bubbleHeightConstaint {
                widthConstraint.constant += 10
                heightConstraint.constant += 10
                
                UIView.animate(withDuration: 0.3,
                               animations: { self.layoutIfNeeded() },
                               completion: { finished in
                                guard finished else { return }
                                widthConstraint.constant -= 10
                                heightConstraint.constant -= 10
                                UIView.animate(withDuration: 0.3,
                                               animations: { self.layoutIfNeeded() })
                })
            }
        }

        
    }
    
    private func setupUI() {
        bubbleView.addSubview(itemsCountLabel)
        cart.addSubview(bubbleView)
        addSubview(cart)
        setupLayout()
    }
    
    private func setupLayout() {
        itemsCountLabel.text = "\(shopItemsCount)"
        bubbleWidthConstraint = bubbleView.widthAnchor.constraint(equalTo: cart.widthAnchor, multiplier: 0.6)
        bubbleHeightConstaint = bubbleView.heightAnchor.constraint(equalTo: cart.widthAnchor, multiplier: 0.6)
        
        NSLayoutConstraint.activate([
            cart.widthAnchor.constraint(equalTo: widthAnchor),
            cart.heightAnchor.constraint(equalTo: heightAnchor),
            cart.centerXAnchor.constraint(equalTo: centerXAnchor),
            cart.centerYAnchor.constraint(equalTo: centerYAnchor),
            bubbleWidthConstraint!,
            bubbleHeightConstaint!,
            bubbleView.topAnchor.constraint(equalTo: cart.topAnchor, constant: -5),
            bubbleView.trailingAnchor.constraint(equalTo: cart.trailingAnchor, constant: 10),
            itemsCountLabel.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor),
            itemsCountLabel.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor)
        ])
    }
}
