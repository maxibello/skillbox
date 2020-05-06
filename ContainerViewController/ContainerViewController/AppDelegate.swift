//
//  AppDelegate.swift
//  ContainerViewController
//
//  Created by Максим Кузнецов on 14.04.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let conVC = storyboard.instantiateViewController(identifier: "ContainerViewController") as! ContainerViewController
        conVC.addVC(UIViewController(), buttonTitle: "one")
        conVC.addVC(UIViewController(), buttonTitle: "two")
        conVC.addVC(UIViewController(), buttonTitle: "three")
        conVC.addVC(UIViewController(), buttonTitle: "four")
        conVC.addVC(UIViewController(), buttonTitle: "five")
        conVC.addVC(UIViewController(), buttonTitle: "six")
        //        conVC.addVC(UIViewController(), buttonTitle: "seven")
        
        let defaultVC = UIViewController()
        defaultVC.view.backgroundColor = .lightGray
        conVC.setDefaultPlaceholder(defaultVC)
        
        window?.rootViewController = conVC
        window?.makeKeyAndVisible()
        
        return true
    }
}

