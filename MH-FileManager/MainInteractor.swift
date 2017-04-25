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
    
    func makeSignIn() {
    
    }
    
    func getCurrentUserInfo() -> String {
        networkManager.getUserInfo {
            [weak self](result: UserModel) in
            print(result)
        }
        return "1"
    }
    
    func getFilesInDocumentsFolder() {
        // Get the document directory url
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let txtFiles = directoryContents.filter{ $0.pathExtension == "txt" }
            print("txt urls:",txtFiles)
            let pngFiles = directoryContents.filter{ $0.pathExtension == "png" }
            print("png urls:",pngFiles)
            let zipFiles = directoryContents.filter{ $0.pathExtension == "zip" }
            print("zip urls:",zipFiles)
            let pdfFiles = directoryContents.filter{ $0.pathExtension == "pdf" }
            print("pdf urls:",pdfFiles)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
