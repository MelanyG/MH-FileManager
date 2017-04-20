//
//  NetworkManager.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation

class NetworkManager: NetworkManagerProtocol {
    
    var token = AccessToken.shared
    
    struct Constant {
        static var APP_ID: String = "5993769"
        static var ProtectedKey: String = "oxCQHIyCimPnliE2BeBA"
        static var ServiceKey: String = "7918d7517918d7517918d751957943a278779187918d75121e0367aa4b51d8f96d14ec3"
        static var RedirectURL: String = "com.mel"
        static var AuthoriseURL: String = "https://oauth.vk.com/authorize?client_id=1&display=page&redirect_uri=http://example.com/callback&scope=friends&response_type=token&v=5.63&state=123456"
    }
    
    var authUrl: URL {
    
        get {
            return URL(string:"https://oauth.vk.com/authorize?client_id=\(Constant.APP_ID)&display=mobile&redirect_uri=\(Constant.RedirectURL)&scope=139270&response_type=token&v=5.63&state=123456&revoke=1")!
        }
        
    }
    
    static let shared: NetworkManager = {
        let instance = NetworkManager ()
        return instance
    }()
    
    func gotTokenUser(_ token: AccessToken, expireDate date: String, revokeToken revToken: String) {
    
    }
}
