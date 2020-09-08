//
//  Stiring+FormattedPrice.swift
//  BlackStar
//
//  Created by Максим on 29.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import Foundation

extension String {
    var formattedPrice: String {
        guard let intPrice = Decimal(string: self) else {
            return "Нет цены"
        }
        return "\(intPrice) ₽"
    }
}
