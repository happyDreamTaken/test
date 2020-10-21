//
//  User.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: NSObject {
    
    static let shared = User()
    
    var phone = ""
    var token = ""
    var webUserId = 0
    var activeStatus = 0
    var vipTime = ""
    var password = ""

    var registerTime = ""
    var nickname = ""
    var headPhoto = ""
    var invitationRewardBalance:Double = 0
    var invitationRewardTotal:Double = 0
    var parentInvitationStatus = 0
    var parentId = 0
    var invitationCount = 0
    
    var isNew = false
    
    var userProtocolText = ""
    var vipProtocolText = ""
    
    fileprivate var phoneKey = "IvyGate_User_Phone"
    fileprivate var userIDKey = "IvyGate_User_UserID"
    fileprivate var tokenKey = "IvyGate_User_Token"
    fileprivate var passwordKey = "IvyGate_User_Password"
    
    fileprivate lazy var dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        
        dateFormatter.locale = Locale(identifier: "zh_CN")
        loadUser()
    }
    //
    func updateUserInfo(_ complete:@escaping ( ()->Void ) ){
        guard token.count > 1 else {
            complete()
            return
        }
        IvyGateServerAPI.shared.userInfo(webUserId) { (response, error) in
            if let json = response, let code = json["code"].int, code == 1 {
                User.shared.updateData(json)
            }
            complete()
        }
    }
    
    func didLogin() -> Bool {
        if token.count > 1 {
            return true
        }
        return false
    }
    
    func getLastDate() -> String{
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let lastDate = dateFormatter.date(from: self.vipTime) else { return "" }
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let str = dateFormatter.string(from: lastDate)
        return str
    }
    
    func getLastDay()->Int{
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeString = self.vipTime + " 23:59:59"
        guard let lastDate = dateFormatter.date(from: timeString) else { return 0 }
        let curDate = Date()
        let components = Calendar.current.dateComponents([.day], from: curDate, to: lastDate)
        var day = components.day ?? 0
        day = day > 0 ? day : 0
        return day
    }
    
    func updateData(_ json:JSON ){
        if let token = json["token"].string, token.count > 0 {
            self.token = token
            IvyGateServerAPI.shared.token = token
        }
        
        let data = json["data"]
        if let webUserId = data["webUserId"].int {
            self.webUserId = webUserId
        }
        if let phone = data["phone"].string {
            self.phone = phone
        }
        if let activeStatus = data["activeStatus"].int {
            self.activeStatus = activeStatus
        }
        if let vipTime = data["vipTime"].string {
            self.vipTime = vipTime
        }
        if let password = data["password"].string {
            self.password = password
        }
        
        if let parentId = data["parentId"].int {
            self.parentId = parentId
        }
        
        if let invitationRewardBalance = data["invitationRewardBalance"].double {
            self.invitationRewardBalance = invitationRewardBalance
        }
        
        if let invitationRewardTotal = data["invitationRewardTotal"].double {
            self.invitationRewardTotal = invitationRewardTotal
        }
        
        if let invitationCount = data["invitationCount"].int {
            self.invitationCount = invitationCount
        }
        
        
        storeUser()
    }
    
    func storeUser(){
        UserDefaults.standard.set(phone, forKey: phoneKey)
        UserDefaults.standard.set(webUserId, forKey: userIDKey)
        UserDefaults.standard.set(token, forKey: tokenKey)
        UserDefaults.standard.set(password, forKey: passwordKey)
    }
    
    func loadUser() {
        if let phone = UserDefaults.standard.string(forKey: phoneKey) {
            self.phone = phone
        }
        if let token = UserDefaults.standard.string(forKey: tokenKey) {
            self.token = token
        }
        if let password = UserDefaults.standard.string(forKey: passwordKey) {
            self.password = password
        }
        self.webUserId = UserDefaults.standard.integer(forKey: userIDKey)
        
    }
    
    func resetUserInfo(){
        self.phone = ""
        self.token = ""
        self.webUserId = 0
        self.activeStatus = 0
        self.vipTime = ""
        self.password = ""
        self.userProtocolText = ""
        self.vipProtocolText = ""
        
        self.storeUser()
    }
    
}
