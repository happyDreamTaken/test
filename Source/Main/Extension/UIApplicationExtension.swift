//
//  UIApplicationExtension.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static let name = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    
    static let displayVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    static let buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    
    static let majorVersion = displayVersion.components(separatedBy: ".").first ?? "0"
    
    static let identifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    
    static let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    static let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    
    static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    
}
