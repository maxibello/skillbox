//
//  UIImagePickerVCViewController.swift
//  s02e08-objc
//
//  Created by Maxim Kuznetsov on 08.01.2021.
//

import UIKit

class UIImagePickerVC: UIViewController, UINavigationControllerDelegate {
    
    let vc = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        swizzleDesriptionImplementation()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func test() {
        print("my method")
    }
    
}

extension UIImagePickerVC: UIImagePickerControllerDelegate {
    
    @objc func swizzleDesriptionImplementation() {
        let aClass: AnyClass! = object_getClass(self)
        let originalMethod = class_getInstanceMethod(aClass, #selector(test))
        let swizzledMethod = class_getInstanceMethod(aClass, #selector(imagePickerController(_:didFinishPickingMediaWithInfo:)))
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("original method")
    }
}
