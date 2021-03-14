//
//  ViewController.swift
//  s02e09-socials
//
//  Created by Maxim Kuznetsov on 03.01.2021.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import SnapKit

class FBViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let token = AccessToken.current, !token.isExpired {
//
//        }
        
        let loginButton = FBLoginButton()
        loginButton.permissions = ["public_profile", "email", "user_friends"]
        view.addSubview(loginButton)
        
        let shareButton = FBShareButton()
        let content = ShareLinkContent()
        content.contentURL = URL(string: "https://skillbox.ru/")!
        shareButton.shareContent = content
        view.addSubview(shareButton)
        
        loginButton.snp.makeConstraints { v in
            v.centerY.equalToSuperview()
            v.centerX.equalToSuperview()
        }
        
        shareButton.snp.makeConstraints { [unowned loginButton] v in
            v.top.equalTo(loginButton.snp.bottom).offset(50)
            v.centerX.equalToSuperview()
        }
        
    }


}
