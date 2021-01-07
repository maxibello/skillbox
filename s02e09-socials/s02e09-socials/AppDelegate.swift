//
//  AppDelegate.swift
//  s02e09-socials
//
//  Created by Maxim Kuznetsov on 03.01.2021.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    
    func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool {
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        
        GIDSignIn.sharedInstance().clientID = "492902451871-msebpcv5l0ni2su4mvu1drhmptp5t3cc.apps.googleusercontent.com"
          GIDSignIn.sharedInstance().delegate = self
        return true }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          print("The user has not signed in before or they have since signed out.")
        } else {
          print("\(error.localizedDescription)")
        }
        return
      }
    }
    
}



