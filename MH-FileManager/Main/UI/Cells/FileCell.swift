//
//  FileCell.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/26/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

protocol PDFCellDelegate {
    
    func didtap(onLink link: String)
    
}

protocol ZipCellDelegate {
    
    func didtapSaveFile(withName name: URL)
    
}

protocol FileCellDelegate {
    
    func pressedSave(fileObject: FileObject)
    func pressedDelete(fileObject: FileObject)
}

class FileCell: UITableViewCell {
    
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileSize: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    var fullFilePath: URL?
    var fileObject: FileObject!
    var status: Bool = false
    var delegate: FileCellDelegate?
    
    
    func configureCell(fileObj: FileObject, inSpecialSection special: Bool) {
        fileName.text = fileObj.fileName
        fileSize.text = "\(fileObj.size) bytes"
        fullFilePath = fileObj.fileNameURL
        fileObject = fileObj
        status = special
        if special {
            saveButton.titleLabel?.text = "Del"
            saveButton.removeTarget(self, action: #selector(FileCell.performDelegateAction), for: .touchUpInside)
            saveButton.addTarget(self, action: #selector(FileCell.performDeleteAction), for: .touchUpInside)
        } else {
            saveButton.titleLabel?.text = "Save"
            saveButton.removeTarget(self, action: #selector(FileCell.performDeleteAction), for: .touchUpInside)
            saveButton.addTarget(self, action: #selector(FileCell.performDelegateAction), for: .touchUpInside)
            
        }
    }
    
    func performDelegateAction() {
        guard delegate != nil else { return }
        delegate?.pressedSave(fileObject: fileObject)
    }
    
    func performDeleteAction() {
        guard delegate != nil else { return }
       delegate?.pressedDelete(fileObject: fileObject)
    }
}

class ZipFileCell: FileCell {
    
    var delegateZip: ZipCellDelegate?
    
    @IBAction func savePressed(_ sender: Any) {
        guard delegateZip != nil else { return }
        
        delegate?.pressedSave(fileObject: fileObject)
    }
    
}

class TextFileCell: FileCell {
    
    @IBOutlet weak var textFileLbl: UILabel!
    
    
    func configureCell(fileObj: TXTFile, inSpecialSection special: Bool) {
        super.configureCell(fileObj: fileObj, inSpecialSection: special)
        if let text =  fileObj.fileText{
            
            textFileLbl.text = text
        }
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        
        performDelegateAction()
        
    }
}

class ImageFileCell: FileCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    func configureCell(fileObj: PNGFile, inSpecialSection special: Bool) {
        super.configureCell(fileObj: fileObj, inSpecialSection: special)
        
        if let im = fileObj.fileImage {
            imgView.image = im
        }
        
    }
    
    @IBAction func savePressed(_ sender: Any) {
        performDelegateAction()
    }
    
}

class PdfFileCell: FileCell, UITextViewDelegate {
    
    @IBOutlet weak var linkTextView: UITextView!
    
    // MARK:- Delegate
    
    var delegatePDF: PDFCellDelegate?
    
    
    func configureCell(fileObj: PDFFile, inSpecialSection special: Bool) {
        
        fileObject = fileObj
        super.configureCell(fileObj: fileObj, inSpecialSection: special)
        
        if fileObj.fileLink != nil {
            linkTextView.delegate = self
            let link = "\(fileObj.fileName!).pdf"
            let theString = NSMutableAttributedString(string: link)
            let theRange = theString.mutableString.range(of: link)
            
            theString.addAttribute(NSLinkAttributeName, value: "ContactUs://", range: theRange)
            
            let theAttribute = [NSForegroundColorAttributeName: UIColor.blue, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue] as [String : Any]
            
            linkTextView.linkTextAttributes = theAttribute
            
            linkTextView.attributedText = theString
            
            theString.setAttributes(theAttribute, range: theRange)
            
            linkTextView.text = link
            linkTextView.sizeToFit()
        }
        
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if (URL.scheme?.hasPrefix("ContactUs://"))! {
            
            return false
        }
        
        delegatePDF?.didtap(onLink: ((fileObject as? PDFFile)?.fileLink)!)
        
        return true
    }
    
    @IBAction func savePressed(_ sender: Any) {
        performDelegateAction()
    }
    
}
