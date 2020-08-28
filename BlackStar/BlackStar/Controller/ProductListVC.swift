//
//  ProductListVC.swift
//  BlackStar
//
//  Created by Максим on 28.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class ProductListVC: UICollectionViewController {
    
    var products: [Product] = []
    var category: Subcategory?
    
    override func viewDidLoad() {
        guard let category = category else { return }
        
        BlackStarApiService.loadProducts(for: category.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                let sortedProducts = products.sorted(by: {
                    left, right in
                    return Int(left.sortOrder) ?? Int.max < Int(right.sortOrder) ?? Int.max
                })
                self.products = sortedProducts
                print(self.products)
                self.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductViewCell
        cell.configure(with: products[indexPath.row])
        
        return cell
    }
}

extension ProductListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width / 2, height: view.bounds.height / 2.5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 0
    }
}
