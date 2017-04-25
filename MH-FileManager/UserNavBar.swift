//
//  UserNavBar.swift
//  MH-FileManager
//
//  Created by Melaniia Hulianovych on 4/24/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit

class UserNavBar: UINavigationBar {

    var imageView: UIImageView?
    var username: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imFrame = CGRect(x: 10, y: 0, width: 50, height: 50)
        imageView = UIImageView.init(frame: imFrame)
        self.addSubview(imageView!)
        
        let lblFrame = CGRect(x: 70, y: 0, width: 120, height: 50)
        username = UILabel(frame: lblFrame)
        username?.textAlignment = NSTextAlignment.right
        username?.textAlignment = .center
        
        username?.textColor = UIColor.white
        username?.shadowColor = UIColor.init(white: 1.0, alpha: 0.2)
        username?.font = UIFont(name: "Menlo", size: CGFloat(17))
        addSubview(username!)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let newSize:CGSize = CGSize(width: self.frame.size.width, height: 55)
        return newSize
    }
    
    func setNavigationBar(withImage imageUrl: String?, username name: String?, userLastName lastName: String?, userNickname nick: String?) {
        if let url = imageUrl {
            imageView?.setImageWithURL(url: url)
        }
        let lblFrame = CGRect(x: self.bounds.midX - 60, y: 0, width: 120, height: 50)
        username?.frame = lblFrame
        var stringname = String()
        if let firstname = name {
            stringname = firstname
            stringname.append(" ")
        }
        if let lastname = lastName {
            stringname.append(lastname)
        }
        if stringname.characters.count > 1 {
            username?.text = stringname
            username?.numberOfLines = 0
        } else {
            if let nickname = nick {
                username?.text = nickname
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
