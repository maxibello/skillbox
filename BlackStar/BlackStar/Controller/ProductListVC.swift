//
//  ProductListVC.swift
//  BlackStar
//
//  Created by Максим on 28.08.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

class ProductListVC: UICollectionViewController {
    
    var products: [[Product]] = [[]]
    var category: Subcategory?
    var formedProduct: FormedProduct?
    
    lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        loader.style = .large
        loader.color = .lightGray
        return loader
    }()
    
    override func viewDidLoad() {
        guard let category = category else { return }
        navigationItem.title = category.name
        
        view.addSubview(loader)
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        loader.startAnimating()
        
        BlackStarApiService.loadProducts(for: category.id) { [weak self] result in
            guard let self = self else { return }
            self.loader.stopAnimating()
            
            switch result {
            case .success(let products):
                let sortedProducts = products.sorted(by: {
                    left, right in
                    return Int(left.sortOrder) ?? Int.max < Int(right.sortOrder) ?? Int.max
                })
                let groupedByArticle = Dictionary(grouping: sortedProducts, by: { $0.article })
                self.products = Array(groupedByArticle.values)
//                print(self.products)
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
        guard let product = products[indexPath.row].first else { return cell }
        cell.configure(with: product)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let formedProduct = FormedProduct(with: products[indexPath.row]) else { return false }
        self.formedProduct = formedProduct
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Product", let productVC = segue.destination as? ProductVC {
            productVC.product = formedProduct
        }
    }
}

extension ProductListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width / 2, height: view.bounds.height / 3)
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
