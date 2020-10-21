//
//  NSSystemManager.swift
//  IvyGate
//
//  Created by MrFeng on 2019/10/23.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit
//@mark 系统功能通用类
class NSSystemManager: NSObject {
    
    static let manager = NSSystemManager.init()
    
    private override init() {
        super.init()
    }
    
    //复制字符串
    func copyString(text:String) {
        UIPasteboard.general.string = text
    }

}
