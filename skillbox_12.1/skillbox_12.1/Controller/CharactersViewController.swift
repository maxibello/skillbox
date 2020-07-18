//
//  ViewController.swift
//  skillbox_12.1
//
//  Created by Максим Кузнецов on 05.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit
import Alamofire

class CharactersViewController: UICollectionViewController {
    
    private var characters: [Character] = []
    private var itemsCount = 0
    private var currentPage = 1
    var requests: [Int : DataRequest] = [:]
    
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
        if !isLoadingItem(for: indexPath) { cell.configure(with: characters[indexPath.row]) }
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
        guard requests[currentPage] == nil else { return }
        
        let newRequest = RickMortyApiService.createNewReqest(for: currentPage)
        requests[currentPage] = newRequest
        RickMortyApiService.loadCharacters(with: newRequest, from: currentPage) { [weak self] result in
            switch result {
            case .success(let charactersResponse):
                    self?.characters += charactersResponse.page
                    if let itemsCount = self?.itemsCount, itemsCount != charactersResponse.allCount {
                        self?.collectionView.reloadData()
                    }
                    self?.itemsCount = charactersResponse.allCount
                    self?.currentPage += 1
                    if let currentPage = self?.currentPage, currentPage > 2 {
                        if let indexPathsToReload = self?.calculateIndexPathsToReload(nextPageItemsCount: charactersResponse.page.count) {
                            if let visibleIndexPathsToReload = self?.visibleIndexPathsToReload(intersecting: indexPathsToReload) {
                                self?.collectionView.reloadItems(at: visibleIndexPathsToReload)
                            }
                        }
                    } else {
                        self?.collectionView.reloadData()
                    }
            case .failure(let networkError):
                
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
    
    private func calculateIndexPathsToReload(nextPageItemsCount: Int) -> [IndexPath]? {
        let startIndex = characters.count - nextPageItemsCount
        let endIndex = startIndex + nextPageItemsCount
        
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    private func isLoadingItem(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= characters.count
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
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // Cancel any in-flight requests for data for the specified index paths.
        if let dataRequest = requests[currentPage] {
            dataRequest.cancel()
            requests.removeValue(forKey: currentPage)
        }
    }
}
