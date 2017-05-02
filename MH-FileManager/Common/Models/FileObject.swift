//
//  FileObject.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/26/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit
import Foundation

class FileObject {

    var fileName: String?
    var fileNameURL: URL?
    var fileExtension: String?
    var size: Int = 0
    var fileUrl: String?
    var type = FileType.General
}

class PNGFile: FileObject {

    var fileImage: UIImage?
    
}

class PDFFile: FileObject {
    
    var fileLink: String?
    
}

class TXTFile: FileObject {
    
    var fileText: String?
    
}
