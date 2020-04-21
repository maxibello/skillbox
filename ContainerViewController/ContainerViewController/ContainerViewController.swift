//
//  ViewController.swift
//  ContainerViewController
//
//  Created by Максим Кузнецов on 14.04.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var childVCStackView: UIStackView!
    
    var buttonsCount = 6
    var buttons: [UIButton] = []
    var childs: [UIViewController] = []
    let colors: [UIColor] = [.red, .yellow, .blue, .green, .brown, .cyan]
    var childActiveState = [false, false, false, false, false, false]
    let defaultVC = UIViewController()
    
    var isEmpty: Bool {
        return childActiveState.allSatisfy({ $0 == false })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    @objc func buttonDidTapped(sender: UIButton) {
        
        guard let buttonLabel = sender.titleLabel?.text,
            let index = Int(buttonLabel) else {
                return
        }
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            addChildVC(childVC: childs[index - 1])
            childActiveState[index - 1] = true
        } else {
            removeChildVC(childVC: childs[index - 1])
            childActiveState[index - 1] = false
        }
        
        if isEmpty {
            addChildVC(childVC: defaultVC)
        } else {
            removeChildVC(childVC: defaultVC)
        }
    }
    
    private func initialSetup() {
        defaultVC.view.backgroundColor = .darkGray
        addChildVC(childVC: defaultVC)
        
        for index in 1...buttonsCount {
            let button = UIButton()
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitle("\(index)", for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.setTitle("\(index)", for: .selected)
            button.addTarget(self, action: #selector(buttonDidTapped(sender:)), for: .touchUpInside)
            buttons.append(button)
            buttonsStackView.addArrangedSubview(button)
            
            let childVC = UIViewController()
            childVC.view.backgroundColor = colors[index - 1]
            childs.append(childVC)
        }
    }
    
    private func addChildVC(childVC: UIViewController) {
        if children.count == 1 {
            removeChildVC(childVC: defaultVC)
        }
        addChild(childVC)
        childVCStackView.addArrangedSubview(childVC.view)
        childVC.didMove(toParent: self)
    }
    
    private func removeChildVC(childVC: UIViewController) {
        childVC.willMove(toParent: nil)
        childVCStackView.removeArrangedSubview(childVC.view)
        childVC.view.removeFromSuperview()
        childVC.removeFromParent()
    }
    
    
}

