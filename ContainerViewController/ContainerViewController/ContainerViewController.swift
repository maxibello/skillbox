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
    
    private var buttons: [UIButton] = []
    private let colors: [UIColor] = [.red, .yellow, .blue, .green, .brown, .cyan]
    private var childActiveState = [false, false, false, false, false, false]
    private var childs: [UIViewController] = []
    private var defaultVC: UIViewController?
    
    private var isEmpty: Bool {
        return childActiveState.allSatisfy({ $0 == false })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    @objc func buttonDidTapped(sender: UIButton) {
        let index = sender.tag
        
        sender.isSelected.toggle()
        
        if sender.isSelected {
            addChildVC(childVC: childs[index])
            childActiveState[index] = true
        } else {
            removeChildVC(childVC: childs[index])
            childActiveState[index] = false
        }
        
        if let defaultVC = defaultVC {
            isEmpty ? addChildVC(childVC: defaultVC) : removeChildVC(childVC: defaultVC)
        }
    }
    
    func addVC(_ vc: UIViewController, buttonTitle: String) {
        assert(childs.count < 6, "Too many child ViewControllers: only 6 allowed")
        
        childs.append(vc)
        
        let button = UIButton()
        button.setTitleColor(.lightGray, for: .normal)
        button.setTitle("\(buttonTitle)", for: .normal)
        button.setTitleColor(.black, for: .selected)
        button.setTitle("\(buttonTitle)", for: .selected)
        button.addTarget(self, action: #selector(buttonDidTapped(sender:)), for: .touchUpInside)
        button.tag = childs.count - 1
        buttons.append(button)
    }
    
    func setDefaultPlaceholder(_ vc: UIViewController) {
        defaultVC = vc
    }
    
    private func initialSetup() {
        if let defaultVC = defaultVC {
            addChildVC(childVC: defaultVC)
        }
        
        for (index, vc) in childs.enumerated() {
            vc.view.backgroundColor = colors[index]
            buttonsStackView.addArrangedSubview(buttons[index])
        }
    }
    
    private func addChildVC(childVC: UIViewController) {
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

