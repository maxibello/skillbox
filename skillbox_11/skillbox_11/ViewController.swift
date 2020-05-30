//
//  ViewController.swift
//  skillbox_11
//
//  Created by Максим Кузнецов on 23.05.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmentedControl()
    }
    
    private func configureSegmentedControl() {
        let segmentedControl = MySegmentedView.loadFromNib()
        segmentedControl.frame = CGRect(x: view.bounds.width / 2 - 60, y: view.bounds.height - 200, width: 120, height: 50)
        segmentedControl.activeSegment = 0
        segmentedControl.leftTitle = "One"
        segmentedControl.rightTitle = "Two"
        segmentedControl.layerColor = .white
        segmentedControl.delegate = self
        
        view.addSubview(segmentedControl)
    }

}

extension ViewController: MySegmentedViewDelegate {
    func segmentPressed(_ owner: MySegmentedView, with index: Int) {
        print("Segment \(index) pressed")
    }
    
    
}

