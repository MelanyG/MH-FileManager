//
//  LoginWireFrame.swift
//  MH-FileManager
//
//  Created by Melany Gulianovych on 4/21/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class LoginWireFrame:LoginWireFrameProtocol {

    var loginViewController: LoginViewController?
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    init() {

    }
    
    func dismissLoginViewController() {
    _ = navigationController?.popViewController(animated: true)

        navigationController?.viewControllers = []
        presentMainScreen()
    }
    
    func presentMainScreen() {
        let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as? MainVC
        mainVC?.navigation = MainWireFrame()
        mainVC?.interactor = MainInteractor()
        mainVC?.navigation?.mainViewController = mainVC
        mainVC?.navigation?.navigationController = navigationController
        navigationController!.pushViewController(mainVC!, animated: true)

    }
    
    func presentLoginScreenInWindow() {

        let logVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        loginViewController = logVC
        loginViewController?.navigation = self

        navigationController!.pushViewController(logVC!, animated: true)
        self.window!.rootViewController = navigationController
        self.window!.makeKeyAndVisible()
    }
    
}
