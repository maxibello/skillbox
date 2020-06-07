//
//  ScrollViewGallery.swift
//  skillbox_10.1
//
//  Created by Максим Кузнецов on 31.05.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class ScrollViewGallery: UIViewController {
    
    let data: [String: [UIImage]] = [
        "Fashion": [
            UIImage(named: "cloth1"),
            UIImage(named: "cloth2"),
            UIImage(named: "cloth3"),
            UIImage(named: "cloth4"),
            UIImage(named: "cloth5")
            ].compactMap { $0 },
        "Sportcars": [
            UIImage(named: "ferrari"),
            UIImage(named: "dodge"),
            UIImage(named: "ford"),
            UIImage(named: "lambo"),
            UIImage(named: "honda")
            ].compactMap { $0 },
        "Billionaires": [
            UIImage(named: "bezos"),
            UIImage(named: "buffet"),
            UIImage(named: "ellison"),
            UIImage(named: "gates")
            ].compactMap { $0 },
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerSV = setupContainerScrollView()
        let svclg = containerSV.contentLayoutGuide // *
        var previousScrollView : UIScrollView? = nil
        
        var yOffset: CGFloat = 0
        for (album, photos) in data {
            var previousAlbumLabel: UILabel? = nil
            
            let albumTitleLabel = UILabel()
            albumTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            albumTitleLabel.text = album
            containerSV.addSubview(albumTitleLabel)
            albumTitleLabel.leadingAnchor.constraint(
                equalTo: svclg.leadingAnchor,
                constant: 10).isActive = true
            albumTitleLabel.topAnchor.constraint(
                equalTo: previousScrollView?.bottomAnchor ?? svclg.topAnchor,
                constant: 10).isActive = true
            albumTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            previousAlbumLabel = albumTitleLabel
            
            let scrollView = UIScrollView(frame: CGRect(x: 0, y: yOffset, width: view.bounds.width, height: view.bounds.width))
            scrollView.backgroundColor = .gray
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            
            var previousImageView : UIImageView? = nil
            for photo in photos {
                let imageView = UIImageView(image: photo)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.contentMode = .scaleAspectFit
                scrollView.addSubview(imageView)
                
                NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                    imageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor),
                    imageView.leftAnchor.constraint(equalTo: previousImageView?.rightAnchor ?? scrollView.leftAnchor),
                    imageView.topAnchor.constraint(equalTo: scrollView.topAnchor)
                ])
                previousImageView = imageView
            }
            
            containerSV.addSubview(scrollView)
            
            NSLayoutConstraint.activate([
                scrollView.leadingAnchor.constraint(
                    equalTo: svclg.leadingAnchor),
                scrollView.topAnchor.constraint(
                    equalTo: previousAlbumLabel?.bottomAnchor ?? svclg.topAnchor,
                    constant: 10),
                scrollView.widthAnchor.constraint(equalTo: containerSV.widthAnchor),
                scrollView.heightAnchor.constraint(equalTo: containerSV.widthAnchor),
                scrollView.contentLayoutGuide.heightAnchor.constraint(equalToConstant: 0),
                scrollView.contentLayoutGuide.rightAnchor.constraint(equalTo: previousImageView?.rightAnchor ?? svclg.rightAnchor)
            ])
            
            previousScrollView = scrollView
            yOffset += view.bounds.width
        }
        svclg.bottomAnchor.constraint(
            equalTo: previousScrollView!.bottomAnchor, constant: 10).isActive = true
        svclg.widthAnchor.constraint(equalToConstant:0).isActive = true
    }
    
    private func setupContainerScrollView() -> UIScrollView {
        let containerSV = UIScrollView()
        containerSV.backgroundColor = .lightGray
        containerSV.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerSV)
        
        NSLayoutConstraint.activate([
            containerSV.topAnchor.constraint(equalTo:self.view.topAnchor),
            containerSV.bottomAnchor.constraint(equalTo:self.view.bottomAnchor),
            containerSV.leadingAnchor.constraint(equalTo:self.view.leadingAnchor),
            containerSV.trailingAnchor.constraint(equalTo:self.view.trailingAnchor),
            containerSV.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return containerSV
    }
}
