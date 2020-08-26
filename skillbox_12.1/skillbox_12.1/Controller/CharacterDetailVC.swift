//
//  CharacterDetailVC.swift
//  skillbox_12.1
//
//  Created by Максим on 04.08.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

protocol CharacterChanged {
    func didChangeCharacter(_: CharacterDetailVC)
}

class CharacterDetailVC: UIViewController {
    var character: Character?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    var delegate: CharacterChanged?
    var imageChanged = false
    
    override func viewDidLoad() {
        if let character = character {
            updateUI(with: character)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        let imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleImageViewTap))
        photoImageView.addGestureRecognizer(imageTapGestureRecognizer)
    }
    
    private func updateUI(with item: Character) {
        navigationItem.title = "Character #\(item.id)"
        nameTextField.text = item.name
        speciesTextField.text = item.species
        photoImageView.image = item.localImage
    }
    
    @IBAction func saveCharacter(_ sender: Any) {
        guard let character = character,
        nameTextField.text != character.name || speciesTextField.text != character.species || imageChanged else { return }
        CharacterDB.sharedInstance.edit(object: character,
                                        name: nameTextField.text ?? "",
                                        species: speciesTextField.text ?? "",
                                        localRevision: true) {
                                            self.delegate?.didChangeCharacter(self)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
}

extension CharacterDetailVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @objc func handleImageViewTap() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        photoImageView.image = image
        character?.saveLocalImage(image)
        imageChanged = true
    }
    
    
}
