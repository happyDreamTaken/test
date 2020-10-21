//
//  AdManager.swift
//  IvyGate
//
//  Created by tjvs on 2019/10/12.
//  Copyright © 2019 yicheng. All rights reserved.
//

import Foundation

class AdManager {
    
    static let shared = AdManager()
    
    var imageLink = ""
    var link = ""
    
    func update(_ success:@escaping ( ()->Void )){
        IvyGateServerAPI.shared.advertInfo { (data, error) in
            if let json = data, let code = json["code"].int, code == 1 {
                let obj = json["data"]
                if let image = obj["advertImg"].string, let link = obj["advertLink"].string {
                    self.imageLink = image
                    self.link = link
                    
                    success()
                }
            }
        }
    }
    
}
