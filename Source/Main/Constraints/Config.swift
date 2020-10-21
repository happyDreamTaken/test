//
//  Config.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import Foundation

enum ServerType {
    case none
    case developer
    case test
    case online
}

class Config {
    
    /// 服务器类型
    static let serverType: ServerType = .developer
    
    /// 调用服务器接口是否加密
    static var serverApiIsCrypto = false
    
    /// 服务器地址
    static let serverAddress:String = {
        switch Config.serverType {
        case .none:
            return ""
        case .developer:
            serverApiIsCrypto = false
            return "http://192.168.0.100:9090"
        case .test:
            serverApiIsCrypto = false
            return "http://192.168.0.100:9090"
        case .online:
            serverApiIsCrypto = true
            return "http://192.168.0.100:9090"
        }
    }()
    
}
