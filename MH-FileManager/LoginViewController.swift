//
//  LoginViewController.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//
import VK_ios_sdk
import UIKit

class LoginViewController: UIViewController, UIWebViewDelegate, VKSdkUIDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var navigation: LoginWireFrame?
    var interactor = LoginInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let request = URLRequest(url:(interactor.networkManager?.authUrl)!)
//        webView.delegate = self

        interactor.networkManager?.sdkInstance?.uiDelegate = self as VKSdkUIDelegate
        
        
//        VKSdk.wakeUpSession([VK_PER_WALL, VK_PER_PHOTOS, VK_PER_OFFLINE]) { (state, error) -> Void in
//            if (state == .authorized) {
//                print ("Authorized")
//            } else if ((error) != nil) {
//                print(error)
//            } else {
//                print ("NotAuthorized")
//                let scopePermissions = ["email", "friends", "wall", "offline", "photos", "notes"]
//                if VKSdk.vkAppMayExists() == true {
//                    VKSdk.authorize(scopePermissions, with: .unlimitedToken)
//                } else {
//                    VKSdk.authorize(scopePermissions, with: [.disableSafariController,.unlimitedToken])
//                }
//                
//            }
//            
//        }
//       interactor.networkManager?.getTokenWithSDK()
//        webView.loadRequest(request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        print("web*****\(request.url!)")
        if request.url?.host == "com.mel" {
            interactor.networkManager?.gotTokenUser(request.description)
            self.navigation?.dismissLoginViewController()
            
            return false
        }
       
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.isHidden = false
        activityIndicator.stopAnimating()
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
