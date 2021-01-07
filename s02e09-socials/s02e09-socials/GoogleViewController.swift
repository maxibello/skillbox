//
//  GoogleViewController.swift
//  s02e09-socials
//
//  Created by Maxim Kuznetsov on 06.01.2021.
//

import UIKit
import GoogleSignIn
import SnapKit

class GoogleViewController: UIViewController {
    
    override func viewDidLoad() {
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        let loginButton = GIDSignInButton()
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { v in
            v.center.equalToSuperview()
        }
    }
}

