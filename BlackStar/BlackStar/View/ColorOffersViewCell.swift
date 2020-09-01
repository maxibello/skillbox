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
    
    func configure(with offer: Offer) {
        sizeLabel.text = offer.size
    }
}

