//
//  UIFontExtension.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

extension UIFont {
    
    func renderWidth(text:String) -> CGFloat {
        let size = CGSize(width: UIScreen.width, height: 600)
        let rect = NSString(string:text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self], context: nil)
        let width = ceil(rect.width)
        return width
    }
    
    func renderHeight(text:String,width:CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: 600)
        let rect = NSString(string:text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self], context: nil)
        let height = ceil(rect.height)
        return height
    }
    
}


