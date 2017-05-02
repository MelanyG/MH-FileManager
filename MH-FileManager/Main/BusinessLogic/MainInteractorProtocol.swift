//
//  MainInteractorProtocol.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/20/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation


protocol MainInteractorProtocol {

    func makeSignOut()
    func makeSignIn()
    func prepareAllData(onCompletion:@escaping (_ array: [FileObject]?, _ savedObjects:[FileObject]?) -> Void)
    
}

protocol MainInteractorUpdateProtocol {
    
    func updateData(newArray array: [FileObject]?, newSavedArray savedObjects:[FileObject]?)
    
}
