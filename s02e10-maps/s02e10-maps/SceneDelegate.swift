//
//  SceneDelegate.swift
//  s02e09-maps
//
//  Created by Maxim Kuznetsov on 10.01.2021.
//

import UIKit
import YandexMapsMobile
import GooglePlaces
import GoogleMaps

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let googleApiKey = "AIzaSyCg2Ej6zOF8VTPl2LMsq0sBJLS778W_0OM"
    let yandexApiKey = "b0047eb3-5f02-4d61-9eec-32bbe58ed3bf"
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        
        let tabBarVC = UITabBarController()
        let mapKitVC = MapKitVC()
        mapKitVC.tabBarItem = UITabBarItem(title: "MapKit", image: nil, selectedImage: nil)
        
        YMKMapKit.setApiKey(yandexApiKey)
        let yandexVC = YandexVC()
        yandexVC.tabBarItem = UITabBarItem(title: "YendexMapKit", image: nil, selectedImage: nil)
        
        let googleVC = GoogleVC()
        googleVC.tabBarItem = UITabBarItem(title: "GoogleMaps", image: nil, selectedImage: nil)
        GMSPlacesClient.provideAPIKey(googleApiKey)
        GMSServices.provideAPIKey(googleApiKey)
        
        tabBarVC.viewControllers = [mapKitVC, googleVC, yandexVC]
        
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
    }
    
}

