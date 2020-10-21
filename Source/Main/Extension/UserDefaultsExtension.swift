//
//  UserDefaultsExtension.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import Foundation

enum UserDefaultsKeyName:String {
    case db_version = "db_version"
}

extension UserDefaults {
    
    func set(_ value: Int, forKey keyName: UserDefaultsKeyName) {
        set(value, forKey: keyName.rawValue)
    }
    
    func set(_ value: Float, forKey keyName: UserDefaultsKeyName) {
        set(value, forKey: keyName.rawValue)
    }
    
    func set(_ value: Double, forKey keyName: UserDefaultsKeyName){
        set(value, forKey: keyName.rawValue)
    }
    
    func set(_ value: Bool, forKey keyName: UserDefaultsKeyName){
        set(value, forKey: keyName.rawValue)
    }
    
    func set(_ url: URL?, forKey keyName: UserDefaultsKeyName){
        set(url, forKey: keyName.rawValue)
    }
    
    func set(_ value: Any?, forKey keyName: UserDefaultsKeyName){
        set(value, forKey: keyName.rawValue)
    }
    
    func object(forKey defaultName: UserDefaultsKeyName) -> Any? {
        return object(forKey: defaultName.rawValue)
    }
    
    func removeObject(forKey defaultName: UserDefaultsKeyName) {
        removeObject(forKey: defaultName.rawValue)
    }
    
    func string(forKey defaultName: UserDefaultsKeyName) -> String? {
        return string(forKey: defaultName.rawValue)
    }

    func array(forKey defaultName: UserDefaultsKeyName) -> [Any]? {
        return array(forKey:defaultName.rawValue)
    }
    
    func dictionary(forKey defaultName: UserDefaultsKeyName) -> [String : Any]? {
        return dictionary(forKey:defaultName.rawValue)
    }
    
    func data(forKey defaultName: UserDefaultsKeyName) -> Data? {
        return data(forKey:defaultName.rawValue)
    }
    func stringArray(forKey defaultName: UserDefaultsKeyName) -> [String]? {
        return stringArray(forKey:defaultName.rawValue)
    }
    
    func integer(forKey defaultName: UserDefaultsKeyName) -> Int {
        return integer(forKey:defaultName.rawValue)
    }
    
    func float(forKey defaultName: UserDefaultsKeyName) -> Float {
        return float(forKey:defaultName.rawValue)
    }
    
    func double(forKey defaultName: UserDefaultsKeyName) -> Double {
        return double(forKey:defaultName.rawValue)
    }
    
    func bool(forKey defaultName: UserDefaultsKeyName) -> Bool {
        return bool(forKey:defaultName.rawValue)
    }
    
    func url(forKey defaultName: UserDefaultsKeyName) -> URL? {
        return url(forKey:defaultName.rawValue)
    }
    
}


