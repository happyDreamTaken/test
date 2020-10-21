//
//  UIImageViewExtension.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    public func setImage(urlString: String, placeholder: String) {
        if let url = URL(string: urlString) {
            let placeholderImage = UIImage(named: placeholder)
            self.kf.setImage(with: url, placeholder: placeholderImage, options: nil )
        }else{
            self.image = UIImage(named: placeholder)
        }
    }
    
    public func setImage(urlString: String, with placeholder: UIImage) {
        if let url = URL(string: urlString) {
            self.kf.setImage(with: url, placeholder: placeholder, options: nil )
        }else{
            self.image = placeholder
        }
    }
}

