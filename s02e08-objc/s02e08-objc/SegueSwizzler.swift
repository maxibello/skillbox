//
//  SegueSwizzler.swift
//  Viper7
//
//  Created by Nikita Arkhipov on 26.10.16.
//  Copyright © 2016 Anvics. All rights reserved.
//

import UIKit

class Box {
    let value: Any
    init(_ value: Any) {
        self.value = value
    }
}

extension UIViewController {
    struct AssociatedKey {
        static var ClosurePrepareForSegueKey = "ClosurePrepareForSegueKey"
    }
    
    typealias ConfiguratePerformSegue = (UIStoryboardSegue) -> ()
    func performSegueWithIdentifier(identifier: String, sender: AnyObject?, configurate: ConfiguratePerformSegue?) {
        swizzlingPrepareForSegue()
        configuratePerformSegue = configurate
        performSegue(withIdentifier: identifier, sender: sender)
    }
    
    private func swizzlingPrepareForSegue() {
        DispatchQueue.once {
            let originalSelector = #selector(UIViewController.prepare)
            let swizzledSelector = #selector(UIViewController.closurePrepareForSegue(segue:sender:))
            
            let instanceClass = UIViewController.self
            
        guard let originalMethod = class_getInstanceMethod(instanceClass, originalSelector),
              let swizzledMethod = class_getInstanceMethod(instanceClass, swizzledSelector) else { return }
        
            let didAddMethod = class_addMethod(instanceClass, originalSelector,
                                               method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(instanceClass, swizzledSelector,
                                    method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    @objc func closurePrepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        configuratePerformSegue?(segue)
        closurePrepareForSegue(segue: segue, sender: sender)
        configuratePerformSegue = nil
    }
    
    var configuratePerformSegue: ConfiguratePerformSegue? {
        get {
            let box = objc_getAssociatedObject(self, &AssociatedKey.ClosurePrepareForSegueKey) as? Box
            return box?.value as? ConfiguratePerformSegue
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.ClosurePrepareForSegueKey, Box(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

public extension DispatchQueue {
    private static var _onceTracker = [String]()
    class func once(file: String = #file, function: String = #function, line: Int = #line, block:()->Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
