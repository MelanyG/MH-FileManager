//
//  UIImageView+Loading.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/24/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImageWithURL(url:String) {
        
        let sessionTask = URLSession.shared
        if url.characters.count < 1 {
            return
        }
        let request = URLRequest(url: URL(string:url)!)
        sessionTask.dataTask(with: request, completionHandler: { [unowned self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                let image: UIImage = UIImage(data: data!)!
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }).resume()
    }
    
    func maskDownloadImageView() {
        self.image = self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = UIColor.white
    }
}
