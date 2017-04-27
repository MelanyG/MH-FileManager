//
//  DataSource.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/26/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation

class DataSource {

    static let shared: DataSource = {
        let instance = DataSource ()
        return instance
    }()

    var pdfFile = 0
    var txtFile = 0
    var pngFile = 0
    var zipFile = 0
    
    var allFiles: [FileObject] = []
    
    
}
