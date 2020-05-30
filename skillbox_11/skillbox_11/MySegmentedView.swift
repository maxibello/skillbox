//
//  MySegmentedView.swift
//  skillbox_11
//
//  Created by Максим Кузнецов on 29.05.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

protocol MySegmentedViewDelegate {
    func segmentPressed(_ owner: MySegmentedView, with index: Int)
}

class MySegmentedView: UIView {
    
    @IBOutlet weak var viewLayer: UIView!
    @IBOutlet weak var checkButtonOne: NSLayoutConstraint!
    @IBOutlet weak var checkButtonTwo: NSLayoutConstraint!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var delegate: MySegmentedViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        viewLayer.layer.cornerRadius = 9
    }
    
    var activeSegment: Int? {
        didSet {
            switch activeSegment {
            case 0:
                checkButtonOne.priority = UILayoutPriority(rawValue: 950)
                checkButtonTwo.priority = UILayoutPriority(rawValue: 750)
            case 1:
                checkButtonOne.priority = UILayoutPriority(rawValue: 750)
                checkButtonTwo.priority = UILayoutPriority(rawValue: 950)
            default:
                fatalError("Segment doesn't exist")
            }
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        }
    }
    
    var leftTitle: String? {
        didSet {
            leftButton.setTitle(leftTitle, for: .normal)
        }
    }
    
    var rightTitle: String? {
        didSet {
            rightButton.setTitle(rightTitle, for: .normal)
        }
    }
    
    var layerColor: UIColor? {
        didSet {
            viewLayer.backgroundColor = layerColor
        }
    }
    
    @IBAction func buttonOne(_ sender: UIButton) {
            activeSegment = 0
        if let activeSegment = activeSegment {
            delegate?.segmentPressed(self, with: activeSegment)
        }
        
        }
        
    @IBAction func buttonTwo(_ sender: UIButton) {
            activeSegment = 1
        if let activeSegment = activeSegment {
            delegate?.segmentPressed(self, with: activeSegment)
        }
        }
    
    static func loadFromNib() -> MySegmentedView {
        let nib = UINib(nibName: "MySegmentedView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! MySegmentedView
    }
    
}
