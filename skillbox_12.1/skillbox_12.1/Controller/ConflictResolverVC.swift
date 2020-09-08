//
//  ConflictResolverVC.swift
//  skillbox_12.1
//
//  Created by Максим on 09.08.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

protocol IConflictResolver {
    func didFinishResolving(_ conflictResolverVC: ConflictResolverVC, resolved: [Character])
}

class ConflictResolverVC: UIViewController {
    
    var items: [CharacterConflict] = []
    
    var currentTuple: CharacterConflict?
    var page: [Character] = []
    var delegate: IConflictResolver?
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var localNameLabel: UILabel!
    @IBOutlet weak var localSpeciesLabel: UILabel!
    @IBOutlet weak var localImageView: UIImageView!
    
    @IBOutlet weak var remoteNameLabel: UILabel!
    @IBOutlet weak var remoteSpeciesLabel: UILabel!
    @IBOutlet weak var remoteImageView: UIImageView!
    
    override func viewDidLoad() {
        pageControl.numberOfPages = items.count
        configurePageUI()
    }
    
    @IBAction func finishRevision(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func configurePageUI() {
        currentTuple = items[pageControl.currentPage]
        
        guard let currentTuple = currentTuple else { return }
        
        let localCharacter = currentTuple.local
        let remoteCharacter = currentTuple.remote
        
        idLabel.text = "ID: \(localCharacter.id)"
        localNameLabel.text = localCharacter.name
        localSpeciesLabel.text = localCharacter.species
        localImageView.image = localCharacter.localImage
        
        remoteNameLabel.text = remoteCharacter.name
        remoteSpeciesLabel.text = remoteCharacter.species
        
        if let remoteImage = remoteCharacter.tempImage {
            remoteImageView.image = remoteImage
        } else {
            downloadImage(for: remoteCharacter)
        }
        
    }
    
    @IBAction func chooseLocal(_ sender: Any) {
        guard let currentTuple = currentTuple else { return }
        if let resolved = page.first(where: { $0.id == currentTuple.local.id }) {
            if let index = page.firstIndex(of: resolved) {
                page[index] = currentTuple.local
            }
        }
        removeResolvedItem()
    }
    
    
    @IBAction func chooseRemote(_ sender: Any) {
        removeResolvedItem()
    }
    
    @IBAction func pageChanged(_ sender: Any) {
        configurePageUI()
    }
    
    private func removeResolvedItem() {
        items.remove(at: pageControl.currentPage)
        pageControl.numberOfPages = items.count
        if items.count > 0 {
            pageControl.currentPage = 0
            configurePageUI()
        } else {
            finishRevision(self)
        }
    }
    
    private func downloadImage(for model: Character) {
        guard let imageURL = URL(string: model.image) else { return }
        RickMortyApiService.downloadImage(url: imageURL) { [weak self] image, error in
                        DispatchQueue.main.async {
                            guard let self = self, let image = image else { return }
                            model.tempImage = image
                            self.remoteImageView.image = image
                        }
                    }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            delegate?.didFinishResolving(self, resolved: page)
        }
    }
    
}
