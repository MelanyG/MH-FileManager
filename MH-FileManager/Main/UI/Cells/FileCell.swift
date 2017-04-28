//
//  FileCell.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/26/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

protocol FileCellDelegate {
    
    func didtap(onLink link: String)

}

protocol ZipCellDelegate {
    
    func didtapSaveFile(withName name: String)
    
}

class FileCell: UITableViewCell {
    
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileSize: UILabel!
    var delegateZip: ZipCellDelegate?
    var fullFilePath: String?
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard delegateZip != nil else { return }
        guard let path = fullFilePath else {
            return
        }
        delegateZip?.didtapSaveFile(withName: path)
        
    }

    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(fileObj: FileObject) {
        fileName.text = fileObj.fileName
        fileSize.text = "\(fileObj.size) bytes"
        fullFilePath = fileObj.fileUrl
    }
}

class TextFileCell: FileCell {
    
    @IBOutlet weak var textFileLbl: UILabel!
    
    
    func configureCell(fileObj: TXTFile) {
        super.configureCell(fileObj: fileObj)
        if let text =  fileObj.fileText{

            textFileLbl.text = text
        }
    }
    
    @IBAction override func saveButtonTapped(_ sender: Any) {
        
    }
}

class ImageFileCell: FileCell {
    
    @IBOutlet weak var imgView: UIImageView!
 
    func configureCell(fileObj: PNGFile) {
        super.configureCell(fileObj: fileObj)
        
        if let im = fileObj.fileImage {
            imgView.image = im
        }

    }
    
    @IBAction override func saveButtonTapped(_ sender: Any) {
        
    }
}

class PdfFileCell: FileCell, UITextViewDelegate {
    
    @IBOutlet weak var linkTextView: UITextView!
    var fileObject: PDFFile?
    
    // MARK:- Delegate
    
    var delegate: FileCellDelegate?
    
    
    func configureCell(fileObj: PDFFile) {
        
        fileObject = fileObj
        super.configureCell(fileObj: fileObj)
        
        if let text =  fileObj.fileLink {
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

        delegate?.didtap(onLink: (fileObject?.fileLink)!)
        
        return true
    }
    
    @IBAction override func saveButtonTapped(_ sender: Any) {
        
    }
}
