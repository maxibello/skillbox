//
//  Battery.swift
//  skillbox_11.1
//
//  Created by Максим Кузнецов on 23.06.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

class Battery: UIView {
    
    var path: UIBezierPath!
    
    public var capacityValue: CGFloat = 1 {
        didSet {
           setupUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        self.clear()
        commonInit()
    }
    
    private func commonInit() {
        let capacityLayer = createCapacityLayer(with: CGFloat(capacityValue))
        let batteryBorderLayer = createBatteryBordersLayer()
        let batteryBorderLayerMask = CAShapeLayer()
        batteryBorderLayerMask.path = path.cgPath
        
        layer.addSublayer(capacityLayer)
        layer.addSublayer(batteryBorderLayer)
        self.layer.mask = batteryBorderLayerMask
    }
    
    private func clear() {
        if let sublayers = layer.sublayers {
            for sublayer in sublayers {
                sublayer.removeFromSuperlayer()
            }
        }
    }
    
    private func createBatteryBordersLayer() -> CAShapeLayer {
        let lineWidth: CGFloat = 15
        
        let step = bounds.width / 5
        let radius = step - lineWidth
        
        path = UIBezierPath()
        
        let center = CGPoint(x: radius + lineWidth / 2, y: step + lineWidth)
        path.addArc(withCenter: center, radius: radius, startAngle: CGFloat(180.0).toRadians(), endAngle: CGFloat(270.0).toRadians(), clockwise: true)
        
        let center2 = CGPoint(x: 2 * step, y: center.y - radius)
        path.addArc(withCenter: center2, radius: step / 2, startAngle: CGFloat(180.0).toRadians(), endAngle: CGFloat(270.0).toRadians(), clockwise: true)
        
        let center3 = CGPoint(x: 3 * step, y: center.y - radius)
        path.addArc(withCenter: center3, radius: step / 2, startAngle: CGFloat(270.0).toRadians(), endAngle: CGFloat(0.0).toRadians(), clockwise: true)
        
        let center4 = CGPoint(x: 4 * step + lineWidth / 2, y: center.y)
        path.addArc(withCenter: center4, radius: radius, startAngle: CGFloat(270.0).toRadians(), endAngle: CGFloat(0.0).toRadians(), clockwise: true)
        
        let center5 = CGPoint(x: center4.x, y: bounds.height - radius - lineWidth / 2)
        path.addArc(withCenter: center5, radius: radius, startAngle: CGFloat(0.0).toRadians(), endAngle: CGFloat(90.0).toRadians(), clockwise: true)
        
        let center6 = CGPoint(x: center.x, y: bounds.height - radius - lineWidth / 2)
        path.addArc(withCenter: center6, radius: radius, startAngle: CGFloat(90.0).toRadians(), endAngle: CGFloat(180.0).toRadians(), clockwise: true)
        path.close()
        
        let batteryBorderLayer = CAShapeLayer()
        batteryBorderLayer.path = path.cgPath
        batteryBorderLayer.fillColor = UIColor.clear.cgColor
        batteryBorderLayer.strokeColor = UIColor.black.cgColor
        batteryBorderLayer.lineWidth = lineWidth
        
        return batteryBorderLayer
    }
    
    func createCapacityLayer(with capacityValue: CGFloat) -> CAShapeLayer {
        let capaticyHeight = bounds.height - bounds.height * capacityValue
        let capacityPath = UIBezierPath()
        capacityPath.move(to: CGPoint(x: 0.0, y: capaticyHeight))
        capacityPath.addLine(to: CGPoint(x: 0.0, y: bounds.height))
        capacityPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        capacityPath.addLine(to: CGPoint(x: bounds.width, y: capaticyHeight))
        capacityPath.close()
        
        let capacityLayer = CAShapeLayer()
        capacityLayer.path = capacityPath.cgPath
        
        switch capacityValue {
        case 0...0.1:
            capacityLayer.fillColor = UIColor.red.cgColor
        case 0.1...0.25:
            capacityLayer.fillColor = UIColor.yellow.cgColor
        default:
            capacityLayer.fillColor = UIColor.green.cgColor
        }
        
        return capacityLayer
    }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * .pi / 180.0
    }
}
