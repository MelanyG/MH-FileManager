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
    var session: URLSession!
    
    struct Constant {
        static var APP_ID: String = "5993769"
        static var ProtectedKey: String = "oxCQHIyCimPnliE2BeBA"
        static var ServiceKey: String = "7918d7517918d7517918d751957943a278779187918d75121e0367aa4b51d8f96d14ec3"
        static var RedirectURL: String = "com.mel"
        static var ApiVCMethods: String = "https://api.vk.com/method/"
        static var AuthoriseURL: String = "https://oauth.vk.com/authorize?client_id=1&display=page&redirect_uri=http://example.com/callback&scope=friends&response_type=token&v=5.63&state=123456"
    }
    
    var authUrl: URL {
    
        get {
            return URL(string:"https://oauth.vk.com/authorize?client_id=\(Constant.APP_ID)&display=mobile&redirect_uri=\(Constant.RedirectURL)&scope=139270&response_type=token&v=5.63&state=123456")!
        }
        
    }
    
    static let shared: NetworkManager = {
        let instance = NetworkManager ()
        return instance
    }()
    
    func gotTokenUser(_ responce: String) {
        var query = responce
        let array = query.components(separatedBy: "#")
        if (array.count) > 1 {
            query = array.last!
        }
        let pairs = query.components(separatedBy: "&")
        for pair in pairs {
            let values = pair.components(separatedBy: "=")
            if values.count == 2 {
                let key = values.first
                if key == "access_token" {
                    token.token = values.last!
                    UserDefaults.standard.set(token.token, forKey: "acc_token")
                } else if key == "expires_in" {
                    let interval = Double(values.last!)
                    token.expiredDate = Date.init(timeIntervalSinceNow: interval!) as Date
                    UserDefaults.standard.set(token.expiredDate, forKey: "expires_in")
                } else if key == "user_id" {
                    token.userID = values.last
                    UserDefaults.standard.set(token.userID, forKey: "user_id")
                  }
            }
        }
    }
    
    func getUserInfo(onCompletion:@escaping (_ result: UserModel) -> Void) {
        
        let url = URL(string:"\(Constant.ApiVCMethods)account.getProfileInfo?&access_token=\(token.token!)&v=5.63")
        var urlRequest = URLRequest.init(url: url!)
        
        urlRequest.httpMethod = "GET"
        session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) {
            [weak self] (data, response, error) -> Void in
            
            if let data = data {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data , options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(jsonResult)
                        onCompletion(UserModel() )
                        
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            } else if let error = error {
                print(error.localizedDescription)
            }
            
            
        }
        task.resume()
    }
    
    func signOutAsUser() {
        
        let cookies = HTTPCookieStorage.shared
        
        for cookie in HTTPCookieStorage.shared.cookies! {
            cookies.deleteCookie(cookie)
        }
        UserDefaults.standard.removeObject(forKey: "acc_token")
        UserDefaults.standard.removeObject(forKey: "expires_in")
        UserDefaults.standard.removeObject(forKey: "user_id")
    }
}
