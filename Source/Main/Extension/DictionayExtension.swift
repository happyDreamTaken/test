//
//  DictionayExtension.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import Foundation

extension Dictionary {
    
    var jsonDataValue:Data? {
        do {
            let options = JSONSerialization.WritingOptions(rawValue: 0)
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
            return jsonData
        } catch let error as NSError {
            #if DEBUG
                print(error)
            #endif
        }
        return nil
    }
    
    var jsonStringValue: String? {
        guard let data = self.jsonDataValue else {
            return nil
        }
        guard let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        return string
    }
}
