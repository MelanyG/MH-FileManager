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
    
    var navigation: LoginWireFrame?
    var interactor = LoginInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url:(interactor.networkManager?.authUrl)!)
        webView.delegate = self
        webView.loadRequest(request)
        
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
}
