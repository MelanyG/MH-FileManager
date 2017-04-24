//
//  RootWireFrame.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class RootWireFrame {
    
    var loginWireFrame: LoginWireFrame?
    let mainWireFrame: MainWireFrame?
    let navigationController: UINavigationController?
    
    init() {
        self.mainWireFrame = MainWireFrame.shared
        navigationController = UINavigationController(navigationBarClass: UserNavBar.self, toolbarClass: nil)
    }
    
    func application(didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?, window: UIWindow) -> Bool {
//        self.loginWireFrame = LoginWireFrame()
        configureNavigationBar()
//        loginWireFrame?.navigationController = navigationController
//        self.loginWireFrame?.window = window
        self.mainWireFrame?.window = window
        self.mainWireFrame?.navigationController = navigationController
        self.mainWireFrame?.presentMainVCInWindow()
//        checkIfUserLoggedIn()
        return true
    }
    
    func checkIfUserLoggedIn() {
        //TODO check for validToken
        if AccessToken.shared.isValidToken() {
           self.mainWireFrame?.presentMainVCInWindow()
        } else {
            loginWireFrame?.presentLoginScreenInWindow()
            
        }
        
    }
    
    func configureNavigationBar() {
        
        let navigationBarAppearace = UINavigationBar.appearance()

        navigationBarAppearace.tintColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        navigationBarAppearace.barTintColor = UIColor(red: 90/255, green: 126/255, blue: 165/255, alpha:1.0)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationBarAppearace.isTranslucent = false

    }
    
}
