//
//  RootWireFrame.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class RootWireFrame {
    
    var loginWireFrame: LoginWireframe?
    let mainWireFrame: MainWireFrame?
   
    
    init() {
        self.mainWireFrame = MainWireFrame.shared
    }
    
    func application(didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?, window: UIWindow) -> Bool {
        self.loginWireFrame = LoginWireframe()
        self.loginWireFrame?.window = window
        self.mainWireFrame?.window = window
        checkIfUserLoggedIn()
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
    
}
