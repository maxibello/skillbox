//
//  ErrorOverlayVC.swift
//  skillbox_14
//
//  Created by Максим Кузнецов on 31.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

protocol ErrorOverlayDismissing {
    func didCloseErrorVC(_: ErrorOverlayVC)
}

class ErrorOverlayVC: UIViewController {
    let repeatButton = UIButton()
    var errorMessage: String?
    var delegate: ErrorOverlayDismissing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let errorMessage = errorMessage else { return }
        configure(with: errorMessage)
    }
    
    private func configure(with message: String) {
        
        view.backgroundColor = .lightGray
        
        let errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = message
        
        repeatButton.translatesAutoresizingMaskIntoConstraints = false
        repeatButton.setTitle("Try Again", for: .normal)
        repeatButton.addTarget(self, action: #selector(closeOverlay), for: .touchUpInside)
        
        view.addSubview(errorLabel)
        view.addSubview(repeatButton)
        NSLayoutConstraint.activate([
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            repeatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            repeatButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 4)
        ])
    }
    
    @objc func closeOverlay() {
        delegate?.didCloseErrorVC(self)
    }
    
}
