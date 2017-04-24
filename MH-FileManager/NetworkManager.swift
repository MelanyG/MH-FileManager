//
//  NetworkManager.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import VK_ios_sdk
import Foundation

class NetworkManager:NSObject, NetworkManagerProtocol, VKSdkDelegate {
    
    var token = AccessToken.shared
    var userInfo = UserModel.shared
    var session: URLSession!
    let sdkInstance = VKSdk.initialize(withAppId: Constant.APP_ID)
    
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
    
    func getTokenWithSDK(onCompletion:@escaping (_ error: Error) -> Void) {
        
        sdkInstance?.register(self as VKSdkDelegate)
        userInfo.getUserdataFromDefaults()
        VKSdk.wakeUpSession([VK_PER_WALL, VK_PER_PHOTOS, VK_PER_OFFLINE]) {
            [weak self] (state, error) -> Void in
            if (state == .authorized) {
                print ("Authorized")
            } else if ((error) != nil) {
                onCompletion(error!)
            } else {
                print ("NotAuthorized")
                let scopePermissions = ["email", "friends", "wall", "offline", "photos", "notes"]
                if VKSdk.vkAppMayExists() == true {
                    VKSdk.authorize(scopePermissions)
                } else {
                    VKSdk.authorize(scopePermissions, with: [.disableSafariController])
                }
                
            }
            
        }
    }
    
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
        
        let url = URL(string:"\(Constant.ApiVCMethods)users.get?fields=photo_100&access_token=\(token.token!)&v=5.63")
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

        VKSdk.forceLogout()
        token.resetToken()
        userInfo.resetUser()
    }
    
    public func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if let token = result.token.accessToken {
            self.token.token = token
            UserDefaults.standard.set(token, forKey: "acc_token")
        }
            let interval = Double(result.token.expiresIn)
            token.expiredDate = Date.init(timeIntervalSinceNow: interval) as Date
            UserDefaults.standard.set(token.expiredDate, forKey: "expires_in")

            token.userID = result.token.userId
            UserDefaults.standard.set(token.userID, forKey: "user_id")

        if let user = result.user {
            userInfo.userID = "\(user.id)"
            userInfo.city = user.city.title
            userInfo.country = user.country.title
            userInfo.photo_50 = user.photo_50
            userInfo.userFirstName = user.first_name
            userInfo.userLastName = user.last_name
            userInfo.userNickName = user.nickname
        }
        
    }
    
    public func vkSdkUserAuthorizationFailed() {
        print("error, User rejected the app!!!")
    }
    
    public func vkSdkAuthorizationStateUpdated(with result: VKAuthorizationResult!) {
        if let user = result.user {
            if let userID = user.id {
                userInfo.userID = "\(userID)"
            }
            if let city = user.city {
                userInfo.city = city.title
                UserDefaults.standard.set(city, forKey: "city")
            }
            if let country = user.country {
                userInfo.country = country.title
                UserDefaults.standard.set(country, forKey: "country")
            }
            if let photo_50 = user.photo_50 {
                userInfo.photo_50 = photo_50
                UserDefaults.standard.set(photo_50, forKey: "photo_50")
            }
            if let first_name = user.first_name {
                userInfo.userFirstName = first_name
                UserDefaults.standard.set(first_name, forKey: "first_name")
            }
            if let last_name = user.last_name {
                userInfo.userLastName = last_name
                UserDefaults.standard.set(last_name, forKey: "last_name")
            }
            if let nickname = user.nickname {
                userInfo.userNickName = nickname
                UserDefaults.standard.set(nickname, forKey: "nickname")
            }
        }
    }
    
    public func vkSdkAccessTokenUpdated(_ newToken: VKAccessToken!, oldToken: VKAccessToken!) {
        if newToken != nil {
            if let token = newToken.accessToken {
                self.token.token = token
                UserDefaults.standard.set(token, forKey: "acc_token")
            }
            let interval = Double(newToken.expiresIn)
            token.expiredDate = Date.init(timeIntervalSinceNow: interval) as Date
            UserDefaults.standard.set(token.expiredDate, forKey: "expires_in")
            
            token.userID = newToken.userId
            UserDefaults.standard.set(token.userID, forKey: "user_id")
            
        }
    }

    public func vkSdkTokenHasExpired(_ expiredToken: VKAccessToken!) {
        print("token expired")
    }
    
}


