//
//  BasketControlHelper.swift
//  BlackStar
//
//  Created by Максим on 06.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class BasketControlHelper {
    
    lazy var basketControl: BasketControl = {
        let basketControl = BasketControl()
        basketControl.translatesAutoresizingMaskIntoConstraints = false
        basketControl.setShopItemsCount(with: CartDBManager.shared.getItemsCount())
        return basketControl
    }()
    
    func updateControl() {
        basketControl.setShopItemsCount(with: CartDBManager.shared.getItemsCount())
    }
    
}
