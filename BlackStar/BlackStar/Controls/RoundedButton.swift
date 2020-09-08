//
//  RoundedButton.swift
//  BlackStar
//
//  Created by Максим on 02.09.2020.
//  Copyright © 2020 Максим. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat = 24 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    var color: UIColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1) {
        didSet {
            setup()
        }
    }
    
    @IBInspectable
    var fontColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1) {
        didSet {
            setup()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        backgroundColor = color
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        setTitleColor(fontColor, for: .normal)
    }
}
