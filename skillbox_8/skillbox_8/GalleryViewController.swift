//
//  ViewController.swift
//  skillbox_8
//
//  Created by Максим Кузнецов on 19.04.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var stepper: UIStepper!
    
    var animationTimer: Timer?
    var startTime: TimeInterval?, endTime: TimeInterval?
    
    let photos: [UIImage?] = [
        UIImage(named: "volvo.jpg"),
        UIImage(named: "diablo.jpg"),
        UIImage(named: "viper.jpg"),
        UIImage(named: "f40.jpg"),
        UIImage(named: "jaga.jpg"),
        UIImage(named: "chev.jpg"),
        UIImage(named: "lotus.jpg"),
        UIImage(named: "honda.jpg"),
        UIImage(named: "lotus.jpg"),
        UIImage(named: "huracan.jpg")
        ].compactMap { $0 }
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var progressView: UIProgressView!
    
    var currentPhoto: UIImage? {
        didSet {
            imageView.image = currentPhoto
        }
    }
    
    var currentIndex: Int = 0 {
        didSet {
            currentPhoto = photos[currentIndex]
            let progress = 1 / Float(photos.count) * Float(currentIndex + 1)
            progressView.setProgress(progress, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentIndex = 0
        slider.maximumValue = (Float(photos.count) - 1) / 10
        stepper.setDecrementImage(UIImage(named: "minus.png")!, for: .normal)
        stepper.setIncrementImage(UIImage(named: "plus.png")!, for: .normal)
    }
    
    @IBAction func nextPhoto(_ sender: Any) {
        if currentIndex >= photos.count - 1 {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
    }
    
    @IBAction func prevPhoto(_ sender: Any) {
        if currentIndex <= 0 {
            currentIndex = photos.count - 1
        } else {
            currentIndex -= 1
        }
    }
    
    func performGalleryAnimation() {
        if animationTimer == nil {
            animationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                self?.updateAnimation()
            }
        }
    }
    
    @objc func updateAnimation() {
        if currentIndex >= photos.count - 1 {
            currentIndex = 0
        } else {
            currentIndex += 1
        }
    }
    
    @IBAction func startAnimation(_ sender: UIButton) {
        performGalleryAnimation()
    }
    
    @IBAction func stopAnimation(_ sender: UIButton) {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        currentIndex = Int(round(sender.value * 10))
    }
    
    @IBAction func stepperChanged(_ sender: UIStepper) {
        currentIndex = Int(sender.value)
    }
}

