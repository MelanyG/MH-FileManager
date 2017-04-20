//
//  LoginInteractor.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation


class LoginInteractor: NSObject, LoginInteractorProtocol {
    
    var view: LoginViewController?
    var networkManager: NetworkManager?
    
    override init() {
        super.init()
        networkManager = NetworkManager.shared
    }
    
}
