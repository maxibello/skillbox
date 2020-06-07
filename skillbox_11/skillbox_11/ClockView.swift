//
//  ClockView.swift
//  skillbox_11
//
//  Created by Максим Кузнецов on 23.05.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

@IBDesignable
class ClockView: UIView {

    private let topMarker = UIView()
    private let rightMarker = UIView()
    private let bottomMarker = UIView()
    private let leftMarker = UIView()
    
    private let hourArrow = UIView()
    private let minuteArrow = UIView()
    private let secondArrow = UIView()
    private let roundedCenter = UIView()
    
    private let markerSmallSide: CGFloat = 5
    private let markerBigSide: CGFloat = 10
    
    @IBInspectable
    private var hourArrowWidth: CGFloat = 5 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable
    private var hourArrowOffset: CGFloat = 50 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable
    private var minuteArrowWidth: CGFloat = 3 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable
    private var minuteArrowOffset: CGFloat = 30 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable
    private var secondArrowWidth: CGFloat = 1 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable
    private var secondArrowOffset: CGFloat = 15 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable
    private var hourArrowColor: UIColor = UIColor.black {
        didSet {
            hourArrow.backgroundColor = hourArrowColor
        }
    }
    
    @IBInspectable
    private var minuteArrowColor: UIColor = UIColor.black {
        didSet {
            minuteArrow.backgroundColor = minuteArrowColor
        }
    }
    
    @IBInspectable
    private var secondArrowColor: UIColor = UIColor.black {
        didSet {
            secondArrow.backgroundColor = secondArrowColor
        }
    }
    
    private let roundedCenterDiameter: CGFloat = 8

    private let clockColor = UIColor.lightGray
    private let markerColor = UIColor.green
    
    private let roundedCenterColor = UIColor.black
    
    var clockHours: CGFloat = 3 {
        didSet {
            updateClockTime()
        }
    }
    
    var clockMinutes: CGFloat = 30 {
        didSet {
            updateClockTime()
        }
    }
    
    var clockSeconds: CGFloat = 45 {
        didSet {
            updateClockTime()
        }
    }
    
    var isSetuped = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isSetuped { return }
        isSetuped = true
        
        backgroundColor = clockColor
        
        let w = bounds.width
        let h = bounds.height
        
        layer.cornerRadius = w / 2
        
        topMarker.frame = CGRect(x: w / 2 - markerSmallSide / 2, y: 0, width: markerSmallSide, height: markerBigSide)
        bottomMarker.frame = CGRect(x: w / 2 - markerSmallSide / 2, y: h - markerBigSide, width: markerSmallSide, height: markerBigSide)
        rightMarker.frame = CGRect(x: w - markerBigSide, y: h / 2 - markerSmallSide / 2, width: markerBigSide, height: markerSmallSide)
        leftMarker.frame = CGRect(x: 0, y: h / 2 - markerSmallSide / 2, width: markerBigSide, height: markerSmallSide)
        
        hourArrow.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        hourArrow.frame = CGRect(x: w / 2 - hourArrowWidth / 2, y: hourArrowOffset, width: hourArrowWidth, height: h / 2 - hourArrowOffset)
        
        minuteArrow.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        minuteArrow.frame = CGRect(x: w / 2 - minuteArrowWidth / 2, y: minuteArrowOffset, width: minuteArrowWidth, height: h / 2 - minuteArrowOffset)
        
        secondArrow.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        secondArrow.frame = CGRect(x: w / 2 - secondArrowWidth / 2, y: secondArrowOffset, width: secondArrowWidth, height: h / 2 - secondArrowOffset)
        
        roundedCenter.frame = CGRect(x: w / 2 - roundedCenterDiameter / 2, y: h / 2 - roundedCenterDiameter / 2, width: roundedCenterDiameter, height: roundedCenterDiameter)
        roundedCenter.backgroundColor = roundedCenterColor
        roundedCenter.layer.cornerRadius = roundedCenterDiameter / 2
        
        updateClockTime()
        
        for marker in [topMarker, bottomMarker, rightMarker, leftMarker] {
            marker.backgroundColor = markerColor
            addSubview(marker)
        }

    }
    
    private func updateClockTime() {
        let hourAngle = CGFloat.pi * 2 * (clockHours / CGFloat(12))
        let minuteAngle = CGFloat.pi * 2 * (clockMinutes / CGFloat(60))
        let secondAngle = CGFloat.pi * 2 * (clockSeconds / CGFloat(60))
        hourArrow.transform = CGAffineTransform(rotationAngle: hourAngle)
        minuteArrow.transform = CGAffineTransform(rotationAngle: minuteAngle)
        secondArrow.transform = CGAffineTransform(rotationAngle: secondAngle)
    }
    
    private func commonInit() {
        addSubview(hourArrow)
        addSubview(minuteArrow)
        addSubview(secondArrow)
        addSubview(roundedCenter)
    }

}
