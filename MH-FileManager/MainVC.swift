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
        
        signInPressed()
        
        configureNavigationBar()
    }
    
    func signInPressed() {
        interactor?.networkManager.sdkInstance?.uiDelegate = self as VKSdkUIDelegate
        interactor?.networkManager.getTokenWithSDK() {
            [weak self] (error: Error?) in
            if let erro = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: erro.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self?.setUserProfile()
                }
            }
        }
    }
    
    func configureNavigationBar() {
        interactor?.networkManager.userInfo.getUserdataFromDefaults()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOut))
        if let font = UIFont(name: "Menlo", size: 17) {
            navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName:font], for: .normal)
        }
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
    }
    
    func setUserProfile() {
        let navbar = navigation?.navigationController?.navigationBar as! UserNavBar
        
        navbar.setNavigationBar(withImage: interactor?.networkManager.userInfo.photo_50, username: interactor?.networkManager.userInfo.userFirstName, userLastName: interactor?.networkManager.userInfo.userLastName, userNickname: interactor?.networkManager.userInfo.userNickName)
    }
    
    func setDefaultProfile() {
        let navbar = navigation?.navigationController?.navigationBar as! UserNavBar
        
        navbar.imageView?.image = UIImage.init(named: "vk")
        navbar.imageView?.maskDownloadImageView()
        navbar.username?.text = ""
    }
    
    func signOut() {
        if navigationItem.rightBarButtonItem?.tag == 0 {
            interactor?.makeSignOut()
            navigationItem.rightBarButtonItem?.title = "Sign in"
            navigationItem.rightBarButtonItem?.tag = 5
            setDefaultProfile()
        } else {
            signInPressed()
            navigationItem.rightBarButtonItem?.tag = 0
            navigationItem.rightBarButtonItem?.title = "Sign out"
        }
        
    }
   
    // VKSDK UI Delegate
    
    public func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.present(controller, animated: true, completion: nil)
    }
    
    public func vkSdkNeedCaptchaEnter(_ captchaError: VKError!){
        let vc = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vc?.present(in: self)
    }
    
    // Status Bar appearance
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        print("****Login deinit****")
    }
}
