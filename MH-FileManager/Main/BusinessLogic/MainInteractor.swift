//
//  MainInteractor.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//
import UIKit
import Foundation

class MainInteractor: MainInteractorProtocol, ZipCellDelegate {
    
    let networkManager = NetworkManager.shared
    let fileManager = MHFileManager.shared
    
    
    func makeSignOut() {
        
        networkManager.signOutAsUser()
    }
    
    func makeSignIn() {
        
    }
    
    func getCurrentUserInfo() -> String {
        networkManager.getUserInfo {
            (result: UserModel) in
            print(result)
        }
        return "1"
    }
    
    func prepareAllData(onCompletion:@escaping (_ array: [FileObject]?) -> Void) {
        fileManager.getFilesInDocumentsFolder{
            (array: [FileObject]?) in
            onCompletion(array)
        }
    }
    
    //MARK ZipCellDelegate
    
    func didtapSaveFile(withName name: String) {
    
        networkManager.postZipFile(withName: name.appending(".zip"))
    }
}
