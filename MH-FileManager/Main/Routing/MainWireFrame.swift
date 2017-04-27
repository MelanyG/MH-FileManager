//
//  MainWireFrame.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class MainWireFrame: MainWireFrameProtocol, FileCellDelegate {
    
    var mainViewController: MainVC?
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    init() {
        
    }
    
    static let shared: MainWireFrame = {
        let instance = MainWireFrame ()
        return instance
    }()
    
    func presentMainVCInWindow() {
        
        let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as? MainVC
        mainViewController = mainVC
        mainViewController?.interactor = MainInteractor()
        mainViewController?.navigation = self
        navigationController!.pushViewController(mainVC!, animated: true)
        self.window!.rootViewController = navigationController
        self.window!.makeKeyAndVisible()
    }
    
    func presentPDFViewController(withLing link:String) {
        
        let pfdwireFrame = PDFWireFrame()
        pfdwireFrame.navigationController = self.navigationController
        pfdwireFrame.presentPDFVC(withLink: link)
        
    }
    
    func didtap(onLink link: String) {
    
        presentPDFViewController(withLing: link)
        
    }
    
    //
    //    func presentLoginScreenInWindow() {
    //
    //        let logVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
    //
    //        logVC?.navigation = LoginWireFrame()
    //        logVC?.navigation?.navigationController = navigationController
    //        navigationController!.pushViewController(logVC!, animated: true)
    //
    //    }
    //
    //    func popToLoginVCInWindow() {
    //        _ = navigationController?.popViewController(animated: true)
    //
    //        navigationController?.viewControllers = []
    //        presentLoginScreenInWindow()
    //    }
    
}
