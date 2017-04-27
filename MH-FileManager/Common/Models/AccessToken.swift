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
    var expiredDate: Date?
    var userID: String?

    static let shared: AccessToken = {
        let instance = AccessToken ()
        return instance
    }()
    
    func isValidToken() -> Bool {
        token = UserDefaults.standard.object(forKey: "acc_token") as? String
        expiredDate = UserDefaults.standard.object(forKey: "expires_in") as? Date
        userID = UserDefaults.standard.object(forKey: "user_id") as? String
        if isValidExpirationDate() {
            return true
        }
        
        return false
    }
    
    func isValidExpirationDate() -> Bool {
    
        guard let expD = expiredDate else {return false}
        if expD as Date > Date() {
            return true
        } else {
            return false
        }
    }
    
    func resetToken() {
        
        UserDefaults.standard.removeObject(forKey: "acc_token")
        UserDefaults.standard.removeObject(forKey: "expires_in")
        UserDefaults.standard.removeObject(forKey: "user_id")
        
        token = nil
        expiredDate = nil
        userID = nil
    }
}
