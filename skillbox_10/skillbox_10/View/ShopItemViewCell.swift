//
//  ShopItemViewCell.swift
//  skillbox_10
//
//  Created by Максим Кузнецов on 09.05.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class ShopItemViewCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with item: ShopItemModel) {
        photo.image = item.photo
        priceLabel.text = Formatter.rouble.string(from: NSNumber(value: item.price))
        titleLabel.text = item.title
        
        if let oldPriceText = Formatter.rouble.string(from: NSNumber(value: item.oldPrice)) {
            let oldPriceStrikedText: NSMutableAttributedString =  NSMutableAttributedString(string: oldPriceText)
            oldPriceStrikedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, oldPriceStrikedText.length))
            oldPriceLabel.attributedText = oldPriceStrikedText
        }
    }
}

extension Formatter {
    static let rouble: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}
