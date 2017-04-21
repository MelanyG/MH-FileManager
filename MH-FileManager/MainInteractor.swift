//
//  MainInteractor.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation

class MainInteractor: MainInteractorProtocol {

    var networkManager = NetworkManager.shared
    
    func makeSignOut() {
    
        networkManager.signOutAsUser()
    }
    
    func getCurrentUserInfo() -> String {
        networkManager.getUserInfo {
            [weak self](result: UserModel) in
            print(result)
//            return "1"
        }
        return "1"
    }
    
}
