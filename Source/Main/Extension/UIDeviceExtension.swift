//
//  UIDeviceExtension.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

extension UIDevice {
    
    static func uuid()-> String {
        var uuidstring = ""
        if let cuuid = UserDefaults.standard.string(forKey: "UIDevice.uuid"), cuuid != "" {
            uuidstring = cuuid
        }else {
            uuidstring = UUID().uuidString
            UserDefaults.standard.set(uuidstring, forKey: "UIDevice.uuid")
            UserDefaults.standard.synchronize()
        }
        return uuidstring
    }
    
    static var isIphoneX: Bool {
        return (UIScreen.width == 375.0 && UIScreen.height == 812.0)
    }
    
}
