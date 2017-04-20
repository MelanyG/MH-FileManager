//
//  AccessToken.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation


class AccessToken {

    var token: String?
    var expiredDate: String?

    static let shared: AccessToken = {
        let instance = AccessToken ()
        return instance
    }()
    
    func isValidToken() -> Bool {
        if token != nil {
            return true
        }
        
        return false
    }
    
}
