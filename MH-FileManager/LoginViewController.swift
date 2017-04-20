//
//  LoginViewController.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var navigation: LoginWireframe?
    var interactor = LoginInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest(url:(interactor.networkManager?.authUrl)!)
        
        webView.loadRequest(request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("web*****\(request.url!)")
        if request.url?.host == "com.mel" {
            var query = request.url?.description
            let array = query?.components(separatedBy: "#")
            if (array?.count)! > 1 {
                query = array?.last
            }
            let pairs = query?.components(separatedBy: "&")
            for pair in pairs! {
                if let pairNew = pair as? String {
                    let values = pairNew.components(separatedBy: "=")
                    if values.count == 2 {
                        let key = values.first
                        if key == "access_token" {
                            print(values.last)
                        } else if key == "expires_in" {
                            let interval = Double(values.last!)
                            print(NSDate.init(timeIntervalSinceNow: interval!))
                        } else if key == "user_id" {
                            print(values.last)
                        }
                    }
                }
            }
            self.navigation?.dismissLoginViewController()
            
            return false
        }
        //        if token.authCode == nil {
        //            if (request.url?.description.range(of:"code=")) != nil {
        //                let code = request.url?.absoluteString.components(separatedBy:"=").last
        //                ServerManager.shared.token.authCode = code
        //
        //                let nc = NotificationCenter.default
        //                nc.post(name:authNotification,
        //                        object: nil,
        //                        userInfo: nil)
        //                dismiss(animated: true, completion: nil)
        //                return false
        //            }
        //            return true
        //        }
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    
}
