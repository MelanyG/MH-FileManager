//
//  PDFWireFrame.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/27/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import Foundation
import UIKit

class PDFWireFrame: PDFWireFrameProtocol {
    
    var pdfViewController: PdfViewController?
    var navigationController: UINavigationController?
    
    func presentPDFVC(withLink link: String) {
        
        pdfViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PDFViewController") as? PdfViewController
        pdfViewController?.navigator = self
        pdfViewController?.interactor = PDFInteractor()
        pdfViewController?.link = link

        navigationController?.pushViewController(pdfViewController!, animated: true)
    }
    
    func closePDFVC() {
        
        navigationController?.popViewController(animated: true)
        pdfViewController = nil

    }
    
}
