//
//  MainVC.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import VK_ios_sdk
import UIKit

class MainVC: UIViewController, VKSdkUIDelegate {
    
    var navigation: MainWireFrame?
    var interactor: MainInteractor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        interactor?.networkManager.sdkInstance?.uiDelegate = self as VKSdkUIDelegate
        interactor?.networkManager.getTokenWithSDK() {
            (error: Error?) in
            if let erro = error {
                let alert = UIAlertController(title: "Alert", message: erro.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        configureNavigationBar()
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
        
    }
    
    func configureNavigationBar() {
        interactor?.networkManager.userInfo.getUserdataFromDefaults()
        let navbar = navigation?.navigationController?.navigationBar as! UserNavBar
        
        navbar.setNavigationBar(withImage: interactor?.networkManager.userInfo.photo_50, username: interactor?.networkManager.userInfo.userFirstName, userLastName: interactor?.networkManager.userInfo.userLastName, userNickname: interactor?.networkManager.userInfo.userNickName)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationController?.title = interactor?.networkManager.userInfo.userFirstName
    }
    
    func signOut() {
        
        interactor?.makeSignOut()
        //        navigation?.popToLoginVCInWindow()
    }
    
    deinit {
        print("****Login deinit****")
    }
    
    // VKSDK UI Delegate
    
    public func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.present(controller, animated: true, completion: nil)
    }
    
    public func vkSdkNeedCaptchaEnter(_ captchaError: VKError!){
        let vc = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vc?.present(in: self)
    }
    
}
