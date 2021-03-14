//
//  UIImage+identifier.swift
//  s02e08-objc
//
//  Created by Maxim Kuznetsov on 01.01.2021.
//

import UIKit

private var AssociatedObjectHandle: UInt8 = 0

extension UIImage {
    var identifier: String {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as! String
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
