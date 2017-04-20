//
//  MainWireFrame.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class MainWireFrame: NSObject, MainWireFrameProtocol {

    var mainViewController: MainVC?
    var window: UIWindow?
    
    static let shared: MainWireFrame = {
        let instance = MainWireFrame ()
        return instance
    }()
    
    func presentMainVCInWindow() {

        let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as? MainVC
        mainViewController = mainVC
        
        self.window!.rootViewController = mainViewController
        self.window!.makeKeyAndVisible()
    }
    
}
