//
//  ViewController.swift
//  skillbox_13
//
//  Created by Максим Кузнецов on 04.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var animationNumberLabel: UILabel!
    @IBOutlet weak var square: UIView!
    var squareHorizontralCenter: NSLayoutConstraint!
    var squareTopSpacing: NSLayoutConstraint!
    
    private var animationNumber: Int = 0 {
        didSet {
            animationNumberLabel.text = "\(animationNumber)"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        squareHorizontralCenter = square.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        squareTopSpacing = square.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90)
        NSLayoutConstraint.activate([squareHorizontralCenter, squareTopSpacing])
        
        animationNumberLabel.text = "\(animationNumber)"
    }
    
    @IBAction func performAnimation(_ sender: UIButton) {
        stopRotation()
        if sender.tag == 1 {
            if animationNumber >= 7 {
                animationNumber = 1
            } else {
                animationNumber += 1
            }
        } else {
            if animationNumber <= 1 {
                animationNumber = 7
            } else {
                animationNumber -= 1
            }
        }
        
        switch animationNumber {
        case 1:
            UIView.animate(withDuration: 2, animations: {
                self.square.backgroundColor = .yellow
            }, completion: { result in
                self.square.backgroundColor = .red
            })
        case 2:
            let yOffset: CGFloat = 90
            let xOffset: CGFloat = (view.bounds.width - square.bounds.width) / 2
            self.squareTopSpacing.constant -= yOffset
            self.squareHorizontralCenter.constant += xOffset
            UIView.animate(withDuration: 2,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.3,
                           options: [.curveEaseInOut],
                           animations: {
                            self.view.layoutIfNeeded()
                            
            },
                           completion: { finished in
                            self.squareTopSpacing.constant += yOffset
                            self.squareHorizontralCenter.constant -= xOffset
                            self.view.layoutIfNeeded()
            })
        case 3:
            let animation = CABasicAnimation(keyPath: "cornerRadius")
            animation.fromValue = NSNumber(value: 0)
            animation.toValue = square.bounds.width / 2
            animation.duration = 2
            square.layer.add(animation, forKey: "cornerRadius")
        case 4:
            UIView.animate(withDuration: 2, animations: {
                self.square.transform = CGAffineTransform(rotationAngle: .pi)
            }, completion: { finished in
                self.square.transform = CGAffineTransform(rotationAngle: 2 * .pi)
            })
        case 5:
            UIView.animate(withDuration: 2, animations: {
                self.square.alpha = 0
            }, completion: { finished in
                self.square.alpha = 1
            })
        case 6:
            UIView.animate(withDuration: 2, animations: {
                self.square.transform = CGAffineTransform(scaleX: 2, y: 2)
            }, completion: { finished in
                self.square.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        case 7:
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = 2
            rotationAnimation.repeatCount = Float.infinity
            square.layer.add(rotationAnimation, forKey: "transform.rotation")
        default:
            print("Wrong animation number")
        }
    }
    
    private func stopRotation() {
        if square.layer.animation(forKey: "transform.rotation") != nil {
            square.layer.removeAnimation(forKey: "transform.rotation")
        }
    }
}


