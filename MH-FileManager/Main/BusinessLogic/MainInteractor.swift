//
//  MainInteractor.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//
import UIKit
import Foundation


class MainInteractor: MainInteractorProtocol, ZipCellDelegate, FileCellDelegate {
    
    let networkManager = NetworkManager.shared
    let fileManager = MHFileManager.shared
    var delegate: MainInteractorUpdateProtocol?
    
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
    
    func prepareAllData(onCompletion:@escaping (_ array: [FileObject]?, _ savedObjects:[FileObject]?) -> Void) {
        fileManager.getFilesInDocumentsFolder {
            (array: [FileObject]?, savedObjects:[FileObject]?) in
            onCompletion(array, savedObjects)
        }
    }
    
    
    // MARK:- ZipCellDelegate
    
    func didtapSaveFile(withName name: URL) {
        
        networkManager.postZipFile(withName: name)
    }
    
   // MARK:- FileCellDelegate
    
    func pressedSave(fileObject: FileObject) {

        fileManager.defineWhetherFilesShouldBeMoved(fileToMove: fileObject, onCompletion:{
            [weak self] (array: [FileObject]?, savedObjects:[FileObject]?) in
            if self?.delegate != nil {
                self?.delegate?.updateData(newArray: array, newSavedArray: savedObjects)
            }
        })

    }
    
    func pressedDelete(fileObject: FileObject) {
        guard let file = fileObject.fileUrl else { return }
        fileManager.deleteFile(atPath: file, onCompletion:{
             [weak self] (array: [FileObject]?, savedObjects:[FileObject]?) in
            if self?.delegate != nil {
                self?.delegate?.updateData(newArray: array, newSavedArray: savedObjects)
            }
        })
    }
}
