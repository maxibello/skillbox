//
//  CustomSwitch.swift
//  skillbox_11.1
//
//  Created by Максим Кузнецов on 16.06.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class CustomSwitch: UIControl {
    public var padding: CGFloat = 5 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var labelPadding: CGFloat = 10 {
        didSet {
            self.setNeedsLayout()
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
            self.setNeedsLayout()
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
            self.setNeedsLayout()
        }
    }
    public var thumbSize = CGSize.zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    public var labelSize = CGSize.zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var isOn = true
    public var animationDuration: Double = 0.5
    
    fileprivate var thumbView = UIView(frame: CGRect.zero)
    fileprivate var textLabel = UILabel(frame: CGRect.zero)
    fileprivate var onPoint = CGPoint.zero
    fileprivate var offPoint = CGPoint.zero
    fileprivate var labelOnPoint = CGPoint.zero
    fileprivate var labelOffPoint = CGPoint.zero
    fileprivate var isAnimating = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    func setupUI() {
        clear()
        clipsToBounds = false
        thumbView.isUserInteractionEnabled = false
        addSubview(textLabel)
        addSubview(thumbView)
    }
    
    private func clear() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isAnimating {
            self.layer.cornerRadius = self.bounds.size.height * self.cornerRadius
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            
            let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(width:
                self.bounds.size.height - 10, height: self.bounds.height - 10)
            let labelSize = self.labelSize != CGSize.zero ? self.labelSize : CGSize(width:
                self.bounds.size.width * 0.4, height: self.bounds.height / 2)
            let yPosition = (self.bounds.size.height - thumbSize.height) / 2
            let labelYPosition = (self.bounds.size.height - labelSize.height) / 2
            
            onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding, y: yPosition)
            offPoint = CGPoint(x: self.padding, y: yPosition)
            
            labelOnPoint = CGPoint(x: self.labelPadding, y: labelYPosition)
            labelOffPoint = CGPoint(x: self.bounds.size.width - labelSize.width - self.labelPadding, y: labelYPosition)
            
            thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)
            thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius
            thumbView.backgroundColor = isOn ? self.thumbOnTintColor : self.thumbOffTintColor
            
            textLabel.frame = CGRect(origin: self.isOn ? self.labelOnPoint : self.labelOffPoint, size: labelSize)
            updateSwitchState()
        }
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        self.animate()
        return true
    }
    
    private func updateSwitchState() {
        textLabel.text = self.isOn ? textOn : textOff
        textLabel.textColor = self.isOn ? self.textOnColor : self.textOffColor
        self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
    }
    
    private func animate() {
        isOn.toggle()
        self.isAnimating = true
        UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseOut,
                                                             UIView.AnimationOptions.beginFromCurrentState], animations: {
                                                                self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
                                                                self.thumbView.backgroundColor = self.isOn ? self.thumbOnTintColor : self.thumbOffTintColor
                                                                
                                                                self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
                                                                self.textLabel.frame.origin.x = self.isOn ? self.labelOnPoint.x : self.labelOffPoint.x
                                                                self.textLabel.text = self.isOn ? self.textOn : self.textOff
                                                                self.textLabel.textColor = self.isOn ? self.textOnColor : self.textOffColor
        }, completion: { _ in
            self.isAnimating = false
            self.sendActions(for: UIControl.Event.valueChanged)
        })
    }
    
    
}

