//
//  ViewController.swift
//  skillbox_12.1
//
//  Created by Максим Кузнецов on 05.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

// po Realm.Configuration.defaultConfiguration.fileURL /Users/testmachine/Library/Developer/CoreSimulator/Devices/12A7532C-F653-4EC3-8315-7831C32FD686/data/Containers/Data/Application/9F2BE4E9-945C-4B45-8640-620EBF6C7BD8/Documents/default.realm

import UIKit
import Alamofire
import RealmSwift


typealias CharacterConflict = (local: Character, remote: Character)

class CharactersViewController: UICollectionViewController {
    
    private var characters: [Character] = []
    private var charactersSnapshot: [Character] = []
    private var conflictedCharacters: [CharacterConflict] = []
    private var itemsCount = 0
    //    private var itemsCountRemote = 0
    private var currentPage = 1
    var requests: [Int : DataRequest] = [:]
    let realmStorage = CharacterDB.sharedInstance
    let userDefaults = UserDefaultsPersistent.shared
    
    var receivedObjects: [Character] = []
    
    var selectedRowIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self,
                                                 action: #selector(handleRefreshControl),
                                                 for: .valueChanged)
        
        collectionView.prefetchDataSource = self
        
        if let lastCachedPage = userDefaults.lastCachedPage, lastCachedPage > 0 {
            currentPage = lastCachedPage
        }
        
        loadFromStorage()
        getAllItemsCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterViewCell", for: indexPath) as! CharacterViewCell
        if !isLoadingItem(for: indexPath) { cell.configure(with: characters[indexPath.row]) }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRowIndex = indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CharacterDetail",
            let characterDetailVC = segue.destination as? CharacterDetailVC,
            let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
            characterDetailVC.character = characters[selectedIndexPath.row]
            characterDetailVC.delegate = self
        }
        
        if segue.identifier == "ResolveConflicts",
            let conflictResolverVC = segue.destination as? ConflictResolverVC {
            conflictResolverVC.page = receivedObjects
            conflictResolverVC.items = conflictedCharacters
            conflictResolverVC.delegate = self
        }
        
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
        
        print("Loading page: \(currentPage)")
        let newRequest = RickMortyApiService.createNewReqest(for: currentPage)
        requests[currentPage] = newRequest
        RickMortyApiService.loadCharacters(with: newRequest) { [weak self] result in
            switch result {
            case .success(let charactersResponse):

                guard let self = self else { return }
                
                self.conflictedCharacters = []
                let modifiedObjects = self.charactersSnapshot.filter( { $0.localRevision })
                self.receivedObjects = charactersResponse.page
                
                for modifiedObject in modifiedObjects {
                    if let receivedObject = self.receivedObjects.first(where: { $0.id == modifiedObject.id }) {
                        self.conflictedCharacters.append((local: modifiedObject, remote: receivedObject))
                        
                    }
                }
                
                if self.itemsCount != charactersResponse.allCount {
                    self.collectionView.reloadData()
                }
                
                self.itemsCount = charactersResponse.allCount
                self.currentPage += 1
                self.userDefaults.lastCachedPage = self.currentPage
                
                if self.currentPage > 2 {
                    if let indexPathsToReload = self.calculateIndexPathsToReload(nextPageItemsCount: charactersResponse.page.count) {
                        let visibleIndexPathsToReload = self.visibleIndexPathsToReload(intersecting: indexPathsToReload)
                        self.collectionView.reloadItems(at: visibleIndexPathsToReload)
                    }
                } else {
                    self.collectionView.reloadData()
                }
                
                if self.conflictedCharacters.count > 0 {
                    self.performSegue(withIdentifier: "ResolveConflicts", sender: self)
                } else {
                    self.characters += self.receivedObjects
                     self.collectionView.reloadData()
                    CharacterDB.sharedInstance.addObjects(objects: self.receivedObjects)
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
    
    private func loadFromStorage() {
        characters = Array(realmStorage.getDataFromDB())
        
        guard itemsCount > 0 else {
            loadData()
            return
        }
    }
    
    private func getAllItemsCount() {
        let newRequest = RickMortyApiService.createNewReqest(for: 1)
        RickMortyApiService.loadCharacters(with: newRequest){ [weak self] result in
            switch result {
            case .success(let charactersResponse):
                if self?.itemsCount != charactersResponse.allCount {
                    self?.itemsCount = charactersResponse.allCount
                    self?.collectionView.reloadData()
                    
                    
                }
        
                
            case .failure(let error):
                print(error.localizedDescription)
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
    
    @objc func handleRefreshControl() {
        currentPage = 1
        requests = [:]
        self.userDefaults.lastCachedPage = 1
        
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
        }
        
        conflictedCharacters = []
        charactersSnapshot = characters
        characters = []
        loadData()
    }
}

extension CharactersViewController: CharacterChanged {
    func didChangeCharacter(_: CharacterDetailVC) {
        if let selectedRowIndex = selectedRowIndex {
            collectionView.reloadItems(at: [selectedRowIndex])
        }
    }
}

extension CharactersViewController: IConflictResolver {
    func didFinishResolving(_ conflictResolverVC: ConflictResolverVC, resolved: [Character]) {
        conflictedCharacters = []
        resolved.forEach({ item in
            if let tempImage = item.tempImage {
                item.saveLocalImage(tempImage)
            }
        })
        CharacterDB.sharedInstance.addObjects(objects: resolved)
        loadFromStorage()

        collectionView.reloadData()
        
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.beginRefreshing()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}
