//
//  VKViewController.swift
//  s02e09-socials
//
//  Created by Maxim Kuznetsov on 05.01.2021.
//

import UIKit
import VK_ios_sdk

class VKViewController: UIViewController {
    
    let vkSdk = VKSdk.initialize(withAppId: "7719173")
    let scope = ["email", "friends", "wall"]
    
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.isEnabled = false
        vkSdk?.uiDelegate = self
        vkSdk?.register(self)
        
        VKSdk.wakeUpSession(scope, complete: {[weak self] state, error in
            if state == .authorized {
                print("Authorized!")
                self?.authButton.setTitle("Друзья", for: .normal)
                self?.shareButton.isEnabled = true
                self?.getFriends()
            } else {
                self?.shareButton.isEnabled = false
                self?.authButton.setTitle("Авторизация VK", for: .normal)
            }
        })
    }    
    
    @IBAction func shareAction(_ sender: Any) {
        let shareVC = VKShareDialogController()
        shareVC.shareLink = VKShareLink(title: "Тестируем VK SDK", link: URL(string: "https://skillbox.ru/")!)
        shareVC.completionHandler = { [weak self] _, _ in self?.dismiss(animated: true, completion: nil)}
        present(shareVC, animated: true, completion: nil)
        
    }
    @IBAction func vkAuth(_ sender: Any) {
        if VKSdk.isLoggedIn() {
            getFriends()
        } else {
            VKSdk.authorize(scope)
        }
        
        
    }
    
    private func getFriends() {
        if VKSdk.isLoggedIn() {
            let userId = VKSdk.accessToken().userId
            if (userId != nil) {
                VKApi.friends().get([VK_API_USER_ID: userId, VK_API_FIELDS: "nickname"]).execute(resultBlock: {[weak self] (response) -> Void in
                    
                    var friendList: [String] = []
                    if let friends = response?.parsedModel as? VKUsersArray {
                        for i in 0..<friends.count {
                            let lastname = friends[i].last_name ?? "Нет фамилии"
                            let firstname = friends[i].first_name ?? "Нет имени"
                            friendList.append(lastname + " " + firstname)
                        }
                        
                        let friendsVC = FriendsTableViewController()
                        friendsVC.friends = friendList
                        friendsVC.title = "Друзья"
                        self?.navigationController?.pushViewController(friendsVC, animated: true)
                    }
                    
                }, errorBlock: { (error) -> Void in
                    print(error)
                })
            }
        }
    }
}



extension VKViewController: VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if let _ = result.token {
            getFriends()
            authButton.setTitle("Друзья", for: .normal)
            shareButton.isEnabled = true
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("vkSdkUserAuthorizationFailed")
    }
    
}

extension VKViewController: VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        navigationController?.topViewController?.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("vkSdkNeedCaptchaEnter")
    }
}
