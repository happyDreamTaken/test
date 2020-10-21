//
//  StringExtension.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import Foundation

extension String {
    
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var urlString: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    var dictionaryValue: [String: Any]? {
        if self.trim == "" {
            return [String: Any]()
        }
        let data = self.data(using: .utf8)
        guard let json = ((try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as? [String: Any]) else{
            return nil
        }
        return json
    }
    
    var isValidTel:Bool {
        if self.isEmpty {
            return false
        }
        guard self.lengthOfBytes(using: .utf8) == 11 else {
            return false
        }
        let format = "^1[0-9]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@",format)
        let isValid = predicate.evaluate(with: self)
        return isValid
    }
    
    func isValidCheckCode(len:Int)->Bool {
        if self.isEmpty {
            return false
        }
        guard self.lengthOfBytes(using: .utf8) == len else {
            return false
        }
        let str = self.trimmingCharacters(in: .decimalDigits)
        if str.count > 0 {
            return false
        }
        return true
    }
    
    func subString(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    func subString(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
        
    }
    
}
