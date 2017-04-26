//
//  FileCell.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/26/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class FileCell: UITableViewCell {
    
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileSize: UILabel!
    @IBOutlet weak var imagView: UIImageView!
    @IBOutlet weak var textDescription: UILabel!
    @IBOutlet weak var imgViewHeight: NSLayoutConstraint!
    
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
        textDescription.isHidden = true
        imagView.isHidden = true
        imgViewHeight.constant = 0
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
    }
}
