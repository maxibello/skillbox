//
//  CustomSwitch.swift
//  skillbox_11.1
//
//  Created by Максим Кузнецов on 16.06.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class CustomSwitch: UIControl {
    public var padding: CGFloat = 0 {
        didSet {
            self.setNeedsUpdateConstraints()
        }
    }
    
    public var labelPadding: CGFloat = 10 {
        didSet {
            self.setNeedsUpdateConstraints()
        }
    }
    
    public var onTintColor = UIColor(red: 56/255, green: 74/255, blue: 92/255, alpha: 1) {
        didSet {
            backgroundColor = isOn ? onTintColor : offTintColor
        }
    }
    public var offTintColor = UIColor.lightGray {
        didSet {
            backgroundColor = isOn ? onTintColor : offTintColor
        }
    }
    public var textOnColor = UIColor(red: 89/255, green: 185/255, blue: 157/255, alpha: 1) {
        didSet {
            textLabel.textColor = self.isOn ? self.textOnColor : self.textOffColor
        }
    }
    public var textOffColor = UIColor.white {
        didSet {
            textLabel.textColor = self.isOn ? self.textOnColor : self.textOffColor
        }
    }
    
    public var textOn: String = "ON" {
        didSet {
            textLabel.text = self.isOn ? textOn : textOff
        }
    }
    
    public var textOff: String = "OFF" {
        didSet {
            textLabel.text = self.isOn ? textOn : textOff
        }
    }
    
    public var cornerRadius: CGFloat = 0.5 {
        didSet {
            layer.cornerRadius = bounds.size.height * self.cornerRadius
        }
    }
    public var thumbOnTintColor = UIColor(red: 89/255, green: 185/255, blue: 157/255, alpha: 1) {
        didSet {
            self.thumbView.backgroundColor = self.thumbOnTintColor
        }
    }
    public var thumbOffTintColor = UIColor.darkGray {
        didSet {
            self.thumbView.backgroundColor = self.thumbOffTintColor
        }
    }
    public var thumbCornerRadius: CGFloat = 0.5 {
        didSet {
            thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius
        }
    }
    public var thumbSize = CGSize.zero {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    public var labelSize = CGSize.zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var isOn = true
    public var animationDuration: Double = 0.5
    
    private var onPoint = CGPoint.zero
    private var offPoint = CGPoint.zero
    private var labelOnPoint = CGPoint.zero
    private var labelOffPoint = CGPoint.zero
    private var thumbOffConstraint: NSLayoutConstraint!
    private var thumbOnConstraint: NSLayoutConstraint!
    private var textOffConstraint: NSLayoutConstraint!
    private var textOnConstraint: NSLayoutConstraint!
    private var thumbWidthConstraint: NSLayoutConstraint!
    private var thumbHeightConstraint: NSLayoutConstraint!
    
    lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    lazy var thumbView: UIView = {
        let thumbView = UIView()
        thumbView.translatesAutoresizingMaskIntoConstraints = false
        thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius
        thumbView.isUserInteractionEnabled = false
        thumbView.backgroundColor = isOn ? self.thumbOnTintColor : self.thumbOffTintColor
        return thumbView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    func setupUI() {
        addSubview(textLabel)
        addSubview(thumbView)
        setupLayout()
    }
    
    private func setupLayout() {
        thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(width:
            self.bounds.size.height - 10, height: self.bounds.height - 10)
        labelSize = self.labelSize != CGSize.zero ? self.labelSize : CGSize(width:
            self.bounds.size.width * 0.4, height: self.bounds.height / 2)
        
        textLabel.textColor = isOn ? textOnColor : textOffColor
        textLabel.text = isOn ? textOn : textOff
        layer.cornerRadius = bounds.size.height * self.cornerRadius
        backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius
        thumbView.backgroundColor = isOn ? self.thumbOnTintColor : self.thumbOffTintColor
        
        thumbOffConstraint =  thumbView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
        thumbOnConstraint = thumbView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        textOffConstraint =  textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -labelPadding)
        textOnConstraint =  textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: labelPadding)
        thumbWidthConstraint = thumbView.widthAnchor.constraint(equalToConstant: thumbSize.width)
        thumbHeightConstraint = thumbView.heightAnchor.constraint(equalToConstant: thumbSize.height)
        
        thumbOffConstraint.isActive = !isOn
        thumbOnConstraint.isActive = isOn
        textOffConstraint.isActive = !isOn
        textOnConstraint.isActive = isOn
        
        NSLayoutConstraint.activate([
            thumbWidthConstraint,
            thumbHeightConstraint,
            thumbView.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.widthAnchor.constraint(equalToConstant: labelSize.width),
            textLabel.heightAnchor.constraint(equalToConstant: labelSize.height),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    public override func updateConstraints() {
        thumbOffConstraint.constant = padding
        thumbOnConstraint.constant = -padding
        textOffConstraint.constant = -labelPadding
        textOnConstraint.constant = labelPadding
        thumbWidthConstraint.constant = thumbSize.width
        thumbHeightConstraint.constant = thumbSize.height
        super.updateConstraints()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        animate()
        return true
    }
    
    private func animate() {
        isOn.toggle()
        thumbOffConstraint.isActive = !isOn
        thumbOnConstraint.isActive = isOn
        textOffConstraint.isActive = !isOn
        textOnConstraint.isActive = isOn
        
        UIView.animate(withDuration: self.animationDuration,
                       delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: [UIView.AnimationOptions.curveEaseOut,
                                 UIView.AnimationOptions.beginFromCurrentState],
                       animations: {
                        self.thumbView.backgroundColor = self.isOn ? self.thumbOnTintColor : self.thumbOffTintColor
                        self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
                        self.textLabel.text = self.isOn ? self.textOn : self.textOff
                        self.textLabel.textColor = self.isOn ? self.textOnColor : self.textOffColor
                        self.layoutIfNeeded()
        }, completion: { _ in
            self.sendActions(for: UIControl.Event.valueChanged)
        })
    }
    
    
}

