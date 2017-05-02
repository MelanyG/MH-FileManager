
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
    
    let directoryNames = ["ZIPFiles", "PNGFiles", "PDFFiles", "TXTFiles"]
    let manager = FileManager.default
    
    static let shared: MHFileManager = {
        let instance = MHFileManager ()
        return instance
    }()
    
    func getFilesInDocumentsFolder(onCompletion:@escaping (_ array: [FileObject], _ savedObjects:[FileObject]?) -> Void) {
        DataSource.shared.allFiles = []
        DataSource.shared.allSavedFiles = []
        DataSource.shared.pdfFile = 0
        DataSource.shared.zipFile = 0
        DataSource.shared.pngFile = 0
        DataSource.shared.txtFile = 0
        do {
            let documentsUrl =  manager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let directoryContents = try manager.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            splitFilesInFolder(array: directoryContents)
            checkForDirectories(inPath: documentsUrl, withAlreadyExisted: directoryContents)
            
            let resourceKeys : [URLResourceKey] = [.creationDateKey, .isDirectoryKey]

            let enumerator = manager.enumerator(at: documentsUrl,
                                                includingPropertiesForKeys: resourceKeys,
                                                options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
                                                    print("directoryEnumerator error at \(url): ", error)
                                                    return true
            })!
            
            for case let fileURL as URL in enumerator {
                let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
                if resourceValues.isDirectory! {
                    let directoryContents = try manager.contentsOfDirectory(at: fileURL, includingPropertiesForKeys: nil, options: [])
                    if directoryNames.contains(fileURL.lastPathComponent) {
                        splitFilesInFolder(array: directoryContents, specialFolder: true)
                    } else {
                        splitFilesInFolder(array: directoryContents)
                    }
                }
                print(fileURL.path, resourceValues.creationDate!, resourceValues.isDirectory!)
                print("***-----------***--------***")
            }
            onCompletion(DataSource.shared.allFiles, DataSource.shared.allSavedFiles)
        } catch {
            print(error)
        }
        
    }
    
    func splitFilesInFolder(array directoryContents:[URL], specialFolder ifYes: Bool = false) {
        
        
        let txtFiles = directoryContents.filter{ $0.pathExtension == "txt" }
        
        for i in 0..<txtFiles.count {
            performFileObjects(url: txtFiles[i], withExt: FileType.Text, specialFolder: ifYes)
        }
        let pngFiles = directoryContents.filter{ $0.pathExtension == "png" }
        for i in 0..<pngFiles.count {
            performFileObjects(url: pngFiles[i], withExt: FileType.PNG, specialFolder: ifYes)
        }
        let zipFiles = directoryContents.filter{ $0.pathExtension == "zip" }
        for i in 0..<zipFiles.count {
            performFileObjects(url: zipFiles[i], withExt: FileType.ZIP, specialFolder: ifYes)
        }
        let pdfFiles = directoryContents.filter{ $0.pathExtension == "pdf" }
        for i in 0..<pdfFiles.count {
            performFileObjects(url: pdfFiles[i], withExt: FileType.PDF, specialFolder: ifYes)
        }
        DataSource.shared.txtFile += txtFiles.count
        DataSource.shared.pdfFile += pdfFiles.count
        DataSource.shared.pngFile += pngFiles.count
        DataSource.shared.zipFile += zipFiles.count
        
    }
    
    func checkForDirectories(inPath path: URL, withAlreadyExisted files:[URL]) {
        
        for i in 0..<directoryNames.count {
            let newDir = path.appendingPathComponent(directoryNames[i])
            
            if files.contains(newDir) {
                print("yes")
            } else {
                createDirectory(atPath: newDir)
            }
            
        }
    }
    
    func defineWhetherFilesShouldBeMoved(fileToMove file: FileObject, onCompletion:@escaping (_ array: [FileObject]?, _ savedObjects:[FileObject]?) -> Void) {
        
        var fileWithExt: String?
        if let name = file.fileName {
            fileWithExt = name
            if let ext = file.fileExtension {
                fileWithExt = fileWithExt?.appending(ext)
            }
        }
        let documentsUrl =  manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        var directoryToMove: URL?
        switch file.type {
        case .Text:
            directoryToMove = documentsUrl.appendingPathComponent("TXTFiles")
        case .PNG:
            directoryToMove = documentsUrl.appendingPathComponent("PNGFiles")
        case .PDF:
            directoryToMove = documentsUrl.appendingPathComponent("PDFFiles")
        case .ZIP:
            directoryToMove = documentsUrl.appendingPathComponent("ZIPFiles")
        default:
            break
        }
        if directoryToMove != nil && fileWithExt != nil {
            if !checkWhetherFile(withPath: fileWithExt!, isInsideFolder: directoryToMove!) {
                moveFile(fromDirectory: file.fileUrl!, toDirectory: directoryToMove!, withPathExt: fileWithExt!, onCompletion: {
               [weak self] (_ success: Bool) in
                    if success {
                        self?.getFilesInDocumentsFolder { (array: [FileObject]?, savedObjects:[FileObject]?) in
                            onCompletion(array, savedObjects)
                        }

                    }
                })
            }
        }
        
    }
    
    func checkWhetherFile(withPath filePath: String, isInsideFolder folderPath: URL) ->Bool {
        let filePath = folderPath.appendingPathComponent(filePath)
              if manager.fileExists(atPath: filePath.path) {
                return true
            } else {
                return false
            }
    }
    
    func moveFile(fromDirectory directoryOne: String, toDirectory directoryTwo: URL, withPathExt filePathExt: String, onCompletion:(_ success: Bool) ->Void) {
        let filePath = directoryTwo.appendingPathComponent(filePathExt)
        do {
            try manager.moveItem(atPath: directoryOne, toPath: filePath.path)
            onCompletion(true)

        } catch let error {
            onCompletion(false)
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func deleteFile(atPath path: String, onCompletion:@escaping (_ array: [FileObject]?, _ savedObjects:[FileObject]?) -> Void) {
        do {
            try manager.removeItem(atPath: path)
            getFilesInDocumentsFolder { (array: [FileObject]?, savedObjects:[FileObject]?) in
                onCompletion(array, savedObjects)
            }
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func createDirectory(atPath directiry:URL) {
        do {
            try manager.createDirectory(atPath: directiry.path,
                                        withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func performFileObjects(url: URL, withExt fileType: FileType, specialFolder ifYes: Bool = false) {
        let stringPath = url.path
        switch fileType {
        case .Text:
            let file = TXTFile()
            getInfoForFile(url: stringPath, forFile: file)
            file.type = FileType.Text
            file.fileExtension = ".txt"
            if file.fileName != nil {
                file.fileText = addContentofTextFile(url: stringPath)
                if ifYes {
                    DataSource.shared.allSavedFiles.append(file)
                } else {
                    DataSource.shared.allFiles.append(file)
                }
            }
        case .PNG:
            let file = PNGFile()
            getInfoForFile(url: stringPath, forFile: file)
            file.type = FileType.PNG
            file.fileExtension = ".png"
            if file.fileName != nil {
                let image = getImageForPNGFile(url: stringPath)
                if image != nil {
                    file.fileImage = image
                }
                if ifYes {
                    DataSource.shared.allSavedFiles.append(file)
                } else {
                    DataSource.shared.allFiles.append(file)
                }
                
            }
        case .PDF:
            let file = PDFFile()
            file.type = FileType.PDF
            file.fileExtension = ".pdf"
            getInfoForFile(url: stringPath, forFile: file)
            if file.fileName != nil {
                file.fileLink = createClickableLinkForPDFFile(url: stringPath)
                if ifYes {
                    DataSource.shared.allSavedFiles.append(file)
                } else {
                    DataSource.shared.allFiles.append(file)
                }
            }
            
        case .ZIP:
            let file = FileObject()
            file.type = FileType.ZIP
            file.fileExtension = ".zip"
            file.fileNameURL = url
            getInfoForFile(url: stringPath, forFile: file)
            if file.fileName != nil {
                if ifYes {
                    DataSource.shared.allSavedFiles.append(file)
                } else {
                    DataSource.shared.allFiles.append(file)
                }
            }
        default: break
        }
        
        
    }
    
    func getInfoForFile(url: String, forFile file: FileObject) {
        var urlNew: String = url
        if url.containsWhitespace {
            urlNew = url.replacingOccurrences(of: " ", with: "%20")
        }
            file.fileName = NSURL(string: urlNew)?.deletingPathExtension?.lastPathComponent

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
