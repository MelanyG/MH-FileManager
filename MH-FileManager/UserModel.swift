//
//  UserModel.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation

class UserModel {

    var userID: String?
    var userName: String?
    
    static let shared: UserModel = {
        let instance = UserModel ()
        return instance
    }()
    
}
