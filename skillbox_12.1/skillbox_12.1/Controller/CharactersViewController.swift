//
//  ViewController.swift
//  skillbox_12.1
//
//  Created by Максим Кузнецов on 05.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class CharactersViewController: UICollectionViewController {
    
    var items: [Character] = []
    var itemsCount = 0
    var currentPage = 1
    var isFetchInProgress = false
    private let itemsPerPage = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.prefetchDataSource = self
        loadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterViewCell", for: indexPath) as! CharacterViewCell
        
        if isLoadingItem(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: items[indexPath.row])
        }
        
        return cell
    }
    
}

extension CharactersViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.bounds.width, height: 128)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    private func loadData() {
        
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        
        HTTPService.loadCharacters(from: currentPage) { [weak self] result in
            switch result {
            case .success(let characters):
                    self?.isFetchInProgress = false
                    self?.items += characters.results
                    self?.itemsCount = characters.info.count
                    self?.currentPage += 1
                    if let currentPage = self?.currentPage, currentPage > 2 {
                        if let indexPathsToReload = self?.calculateIndexPathsToReload() {
                            self?.collectionView.reloadItems(at: indexPathsToReload)
                        }
                    } else {
                        self?.collectionView.reloadData()
                    }
            case .failure(let networkError):
                self?.isFetchInProgress = false
                
                let alert = UIAlertController(title: "Network Error", message: networkError.localizedDescription, preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
                    self?.loadData()
                })
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(retryAction)
                alert.addAction(okAction)
                self?.present(alert, animated: true)
            }
        }
    }
}

extension CharactersViewController: UICollectionViewDataSourcePrefetching {
    
    private func calculateIndexPathsToReload() -> [IndexPath] {
        let startIndex = items.count - itemsPerPage
        let endIndex = startIndex + itemsPerPage
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    private func isLoadingItem(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= items.count
    }
    
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleItems = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleItems).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingItem) {
            loadData()
        }
    }
}
