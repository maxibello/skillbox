//
//  TableViewGalleryTableViewController.swift
//  skillbox_10.1
//
//  Created by Максим Кузнецов on 01.06.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class TableViewGallery: UITableViewController {
    
    struct Album {
        let title: String
        let photos: [UIImage]
    }
    
    let data: [Album] = [Album(title: "Fashion",
                               photos:  [UIImage(named: "cloth1"),
                                         UIImage(named: "cloth2"),
                                         UIImage(named: "cloth3"),
                                         UIImage(named: "cloth4"),
                                         UIImage(named: "cloth5")
                                ].compactMap { $0 }),
                         Album(title: "Sportcars", photos: [
                            UIImage(named: "ferrari"),
                            UIImage(named: "dodge"),
                            UIImage(named: "ford"),
                            UIImage(named: "lambo"),
                            UIImage(named: "honda")
                            ].compactMap { $0 }),
                         Album(title: "Billionaires", photos: [
                            UIImage(named: "bezos"),
                            UIImage(named: "buffet"),
                            UIImage(named: "ellison"),
                            UIImage(named: "gates")
                            ].compactMap { $0 })]
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell",
                                                 for: indexPath) as! AlbumTableCell
        cell.albumTitleLable.text = data[indexPath.row].title
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? AlbumTableCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
}

extension TableViewGallery: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[collectionView.tag].photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell",
                                                      for: indexPath) as! PhotoCell
        
        cell.photoImageView.image = data[collectionView.tag].photos[indexPath.row]
        return cell
    }

}
