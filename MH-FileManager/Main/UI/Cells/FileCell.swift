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

class FileCell: UITableViewCell {
    
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileSize: UILabel!
    
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
        //       textDescription.isHidden = true
        //        imagView.isHidden = true
        /*
         imgViewHeight.constant = 50
         switch fileObj.type {
         case .Text:
         let obj = fileObj as! TXTFile
         if let text =  obj.fileText{
         textDescription.isHidden = false
         textDescription.text = text
         }
         case .PDF:
         let obj = fileObj as! PDFFile
         textDescription.isHidden = false
         textDescription.text = "http:///Users/mhul/Library/Developer/CoreSimulator/Devices/16788ED0-C122-4549-A725-BE277A30115A/data/Containers/Data/Application/F47C8ACF-780E-4680-B175-3F8FAB976E92/Documents/Kent_Beck_Test-Driven_Development_by_Example.pdf"
         case .PNG:
         let obj = fileObj as! PNGFile
         if let im = obj.fileImage {
         imagView.isHidden = false
         imgViewHeight.constant = 50
         imagView.image = im
         }
         default: break
         
         }
         */
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
}

class ImageFileCell: FileCell {
    
    @IBOutlet weak var imgView: UIImageView!
 
    func configureCell(fileObj: PNGFile) {
        super.configureCell(fileObj: fileObj)
        
        if let im = fileObj.fileImage {
            imgView.image = im
        }

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
}
