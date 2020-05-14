//
//  ViewController.swift
//  skillbox_10
//
//  Created by Максим Кузнецов on 09.05.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    let shopItems: [ShopItemModel] = [
        ShopItemModel(title: "Сорочка Armani", price: 7500, oldPrice: 10000, photo: UIImage(named: "cloth1.jpg")),
        ShopItemModel(title: "Платье Slava Zaitsev", price: 20000, oldPrice: 22000, photo: UIImage(named: "cloth2.jpg")),
        ShopItemModel(title: "Джемпер HUGO BOSS", price: 6000, oldPrice: 5000, photo: UIImage(named: "cloth3.jpg")),
        ShopItemModel(title: "Ретузы ADIDAS", price: 3000, oldPrice: 5000, photo: UIImage(named: "cloth4.jpg")),
        ShopItemModel(title: "Сарафан PRADA", price: 14000, oldPrice: 20000, photo: UIImage(named: "cloth5.jpg")),
        ShopItemModel(title: "Портупея BEFREE", price: 8000, oldPrice: 9000, photo: UIImage(named: "cloth6.jpg"))
    ]
    
}

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shopItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopItemViewCell", for: indexPath) as! ShopItemViewCell
        cell.configure(with: shopItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width / 2,
                      height: view.bounds.height / 2)
    }
    
    
}


