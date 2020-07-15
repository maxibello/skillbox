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
    
    lazy var square: UIView = {
        let square = UIView()
        square.translatesAutoresizingMaskIntoConstraints = false
        return square
    }()
    
    var squareHorizontralCenter: NSLayoutConstraint!
    var squareTopSpacing: NSLayoutConstraint!
    
    private var animationNumber: Int = 0 {
        didSet {
            animationNumberLabel.text = "\(animationNumber)"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(square)
        
        squareHorizontralCenter = square.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        squareTopSpacing = square.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90)
        NSLayoutConstraint.activate([
            squareHorizontralCenter,
            squareTopSpacing,
            square.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            square.heightAnchor.constraint(equalTo: square.widthAnchor)
        ])
        square.backgroundColor = .red
        
        animationNumberLabel.text = "\(animationNumber)"
    }
    
    @IBAction func performAnimation(_ sender: UIButton) {
        resetViewToDefaults()
        
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
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 2,
                delay: 0,
                options: .curveLinear,
                animations: {
                    self.square.backgroundColor = .yellow
            }, completion: { animatingPosition in
                guard animatingPosition == .end else { return }
                UIView.animate(withDuration: 2, animations: {
                    self.square.backgroundColor = .red
                }, completion: nil)
                
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
                            guard finished else { return }
                            self.squareTopSpacing.constant += yOffset
                            self.squareHorizontralCenter.constant -= xOffset
                            UIView.animate(withDuration: 2,
                                           delay: 0,
                                           usingSpringWithDamping: 0.5,
                                           initialSpringVelocity: 0.3,
                                           options: [.curveEaseInOut],
                                           animations: {
                                            self.view.layoutIfNeeded()
                            }, completion: nil)
            })
        case 3:
            CATransaction.begin()
            let animationCorner = CABasicAnimation(keyPath: "cornerRadius")
            animationCorner.fromValue = NSNumber(value: 0)
            animationCorner.toValue = square.bounds.width / 2
            animationCorner.duration = 2
            
            CATransaction.setCompletionBlock({
                guard self.animationNumber == 3 else { return }
                let animationRollback = CABasicAnimation(keyPath: "cornerRadius")
                animationRollback.fromValue = self.square.bounds.width / 2
                animationRollback.toValue = NSNumber(value: 0)
                animationRollback.duration = 2
                self.square.layer.add(animationRollback, forKey: "cornerRadiusDesc")
            })
            
            square.layer.add(animationCorner, forKey: "cornerRadiusInc")
            CATransaction.commit()
            
        case 4:
            UIView.animate(withDuration: 2, animations: {
                self.square.transform = CGAffineTransform(rotationAngle: .pi)
            }, completion: { finished in
                guard finished else { return }
                UIView.animate(withDuration: 2, animations: {
                    self.square.transform = CGAffineTransform(rotationAngle: 2 * .pi)
                }, completion: nil)
            })
        case 5:
            UIView.animate(withDuration: 2, animations: {
                self.square.alpha = 0
            }, completion: { finished in
                guard finished else { return }
                UIView.animate(withDuration: 2, animations: {
                    self.square.alpha = 1
                }, completion: nil)
            })
        case 6:
            UIView.animate(withDuration: 2, animations: {
                self.square.transform = CGAffineTransform(scaleX: 2, y: 2)
            }, completion: { finished in
                guard finished else { return }
                UIView.animate(withDuration: 2, animations: {
                    self.square.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
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
    
    private func resetViewToDefaults() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.commit()
        
        square.layer.removeAllAnimations()
        square.backgroundColor = .red
        squareTopSpacing.constant = 90
        squareHorizontralCenter.constant = 0
        square.transform = CGAffineTransform(rotationAngle: 2 * .pi)
        square.transform = CGAffineTransform(scaleX: 1, y: 1)
        square.alpha = 1
    }
}


