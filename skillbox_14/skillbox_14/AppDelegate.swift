//
//  AppDelegate.swift
//  skillbox_14
//
//  Created by Максим Кузнецов on 12.07.2020.
//  Copyright © 2020 Максим Кузнецов. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        var persistentContainer: NSPersistentContainer {
            let container = NSPersistentContainer(name: "skillbox_14")
            container.persistentStoreDescriptions.first?.shouldAddStoreAsynchronously = true
            container.loadPersistentStores { description, error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            return container
        }

        let serviceLocator = ServiceLocator.shared
        
//        DispatchQueue.global(qos: .background).async {
//            do {
//                let realm = try Realm()
//                serviceLocator.add(services: realm)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
            do {
                let realm = try Realm()
                serviceLocator.add(services: realm)
            } catch {
                print(error.localizedDescription)
            }

        serviceLocator.add(services:UserDefaultsPersistent.shared)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

