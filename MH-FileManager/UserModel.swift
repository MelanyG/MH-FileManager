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
    var userNickName: String?
    var userFirstName: String?
    var userLastName: String?
    var city: String?
    var country: String?
    var photo_50: String?
    
    static let shared: UserModel = {
        let instance = UserModel ()
        return instance
    }()
    
    func resetUser() {
        
        UserDefaults.standard.removeObject(forKey: "city")
        UserDefaults.standard.removeObject(forKey: "country")
        UserDefaults.standard.removeObject(forKey: "photo_50")
        UserDefaults.standard.removeObject(forKey: "first_name")
        UserDefaults.standard.removeObject(forKey: "last_name")
        UserDefaults.standard.removeObject(forKey: "nickname")
        
        userID = nil
        userNickName = nil
        userFirstName = nil
        userLastName = nil
        city = nil
        country = nil
        photo_50 = nil
        
    }
    
    func getUserdataFromDefaults() {
        
        if let usID = UserDefaults.standard.object(forKey: "user_id") as? String {
            userID = usID
        }
        if let usCity = UserDefaults.standard.object(forKey: "city") as? String {
            city = usCity
        }
        if let usCountry = UserDefaults.standard.object(forKey: "country") as? String {
            country = usCountry
        }
        if let usPhoto = UserDefaults.standard.object(forKey: "photo_50") as? String {
            photo_50 = usPhoto
        }
        if let usFName = UserDefaults.standard.object(forKey: "first_name") as? String {
            userFirstName = usFName
        }
        if let usLName = UserDefaults.standard.object(forKey: "last_name") as? String {
            userLastName = usLName
        }
        if let usNName = UserDefaults.standard.object(forKey: "nickname") as? String {
            userNickName = usNName
        }
        
    }
}
