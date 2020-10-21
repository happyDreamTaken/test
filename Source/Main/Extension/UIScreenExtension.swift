//
//  UIScreenExtension.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

extension UIScreen {
    
    static let width:CGFloat = ( main.bounds.height > main.bounds.width ) ? main.bounds.width : main.bounds.height
    
    static let height:CGFloat = ( main.bounds.height > main.bounds.width ) ? main.bounds.height : main.bounds.width
    
    static let size = CGSize(width: width, height: height)
    
}
