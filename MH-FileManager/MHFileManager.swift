//
//  MHFileManager.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/26/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit
import Foundation

        enum FileType {
        case Text
        case PNG
        case PDF
        case ZIP
        case General
    }

class MHFileManager {
    

    let manager = FileManager.default
    
    static let shared: MHFileManager = {
        let instance = MHFileManager ()
        return instance
    }()
    
    func getFilesInDocumentsFolder(onCompletion:@escaping (_ array: [FileObject]) -> Void) {
        
        let documentsUrl =  manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try manager.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let txtFiles = directoryContents.filter{ $0.pathExtension == "txt" }
            for i in 0..<txtFiles.count {
                performFileObjects(url: txtFiles[i].path, withExt: FileType.Text)
            }
            let pngFiles = directoryContents.filter{ $0.pathExtension == "png" }
                   for i in 0..<pngFiles.count {
                    performFileObjects(url: pngFiles[i].path, withExt: FileType.PNG)
            }
            let zipFiles = directoryContents.filter{ $0.pathExtension == "zip" }
            for i in 0..<zipFiles.count {
                performFileObjects(url: zipFiles[i].path, withExt: FileType.ZIP)
            }
            let pdfFiles = directoryContents.filter{ $0.pathExtension == "pdf" }
            for i in 0..<pdfFiles.count {
                performFileObjects(url: pdfFiles[i].path, withExt: FileType.PDF)
            }
            DataSource.shared.txtFile = txtFiles.count
            DataSource.shared.pdfFile = pdfFiles.count
            DataSource.shared.pngFile = pngFiles.count
            DataSource.shared.zipFile = zipFiles.count
            onCompletion(DataSource.shared.allFiles)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func performFileObjects(url: String, withExt fileType: FileType) {
        switch fileType {
        case .Text:
            let file = TXTFile()
            getInfoForFile(url: url, forFile: file)
            file.type = FileType.Text
            if file.fileName != nil {
                file.fileText = addContentofTextFile(url: url)
                DataSource.shared.allFiles.append(file)
            }
        case .PNG:
            let file = PNGFile()
            getInfoForFile(url: url, forFile: file)
            file.type = FileType.PNG
            if file.fileName != nil {
                let image = getImageForPNGFile(url: url)
                if image != nil {
                    file.fileImage = image
                }
                DataSource.shared.allFiles.append(file)
            }
        case .PDF:
            let file = PDFFile()
            file.type = FileType.PDF
            getInfoForFile(url: url, forFile: file)
            if file.fileName != nil {
                file.fileLink = createClickableLinkForPDFFile(url: url)
                DataSource.shared.allFiles.append(file)
            }

        case .ZIP:
            let file = FileObject()
            file.type = FileType.ZIP
            getInfoForFile(url: url, forFile: file)
            if file.fileName != nil {
                DataSource.shared.allFiles.append(file)
            }
        default: break
        }
        
        
    }
    
    func getInfoForFile(url: String, forFile file: FileObject) {
        
        file.fileName = NSURL(string: url)?.deletingPathExtension?.lastPathComponent
        file.fileUrl = url
        file.size = getFileSize(url: url)
        
    }
    
    func createClickableLinkForPDFFile(url: String) -> String {
        return url
    }
    
    func addContentofTextFile(url: String) -> String {
        do {
            let contentsOfFile = try? String(contentsOfFile: url, encoding: String.Encoding.utf8)
            let lastIndex = (contentsOfFile?.characters.count)! > 500 ? 500 : (contentsOfFile?.characters.count)! - 1
            return contentsOfFile![0...lastIndex]
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    
    func getImageForPNGFile(url: String) -> UIImage? {
        
        return UIImage(contentsOfFile: url)
        
    }
    
    func getFileSize(url: String) -> Int {
        
        do {
            let attribs: NSDictionary = try manager.attributesOfItem(atPath: url) as NSDictionary
            let size = attribs["NSFileSize"] as! NSNumber
            return size.intValue
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
        return 0
    }
    

    
}
