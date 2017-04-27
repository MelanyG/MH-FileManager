//
//  PdfViewController.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/27/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController, UIWebViewDelegate {

    var link: String!
    var navigator: PDFWireFrame? = nil
    var interactor: PDFInteractor? = nil
    
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        webView.delegate = self
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        
    }
    
    func configureNavigationBar() {
        

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeScreen))
        if let font = UIFont(name: "Menlo", size: 17) {
            navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName:font], for: .normal)
        }
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }

    func closeScreen() {
        navigator?.closePDFVC()
    }
    
    // Status Bar appearance
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Deinit
    
    deinit {
        print("****PDF deinit****")
        NotificationCenter.default.removeObserver(self, name: authNotification, object: nil)
    }

}
