//
//  InviteLogManger.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import Foundation

struct InviteLog {
    var invitationLogId = 0
    var createTime = ""
    var webUserId = 0
    var phone = ""
    var rewardTime = ""
    var rewardAmount = 0
    var vipPackageId = 0
}

class InviteLogManger {
    
    static let shared = InviteLogManger()
    lazy var inviteLogArray:[InviteLog] = []
    var pageIndex = 1
    let pageLimit = 20
    
    func update( complete:@escaping ( (_ error:String?)->Void ) ){
        let phone = User.shared.phone
        IvyGateServerAPI.shared.myInviteList(phone: phone, page: 1, limit: pageLimit) { (data, error) in
            if let errorMsg = error {
                complete(errorMsg)
                return
            }
            if let json = data, json["code"].int == 1,let array = json["data"]["records"].array {
                self.inviteLogArray.removeAll()
                self.pageIndex = 1
                for item in array {
                    var bean = InviteLog()
                    bean.invitationLogId = item["invitationLogId"].intValue
                    bean.createTime = item["createTime"].stringValue
                    bean.webUserId = item["webUserId"].intValue
                    bean.phone = item["phone"].stringValue
                    bean.rewardTime = item["rewardTime"].stringValue
                    bean.rewardAmount = item["rewardAmount"].intValue
                    bean.vipPackageId = item["vipPackageId"].intValue
                    self.inviteLogArray.append(bean)
                }
                complete(nil)
            }else{
                complete("数据解析错误")
            }
        }
    }
    
    func loadNextPage(complete:@escaping ( (_ error:String?)->Void )){
        let phone = User.shared.phone
        let page = self.pageIndex + 1
        IvyGateServerAPI.shared.myInviteList(phone: phone, page: page, limit: pageLimit) { (data, error) in
            if let errorMsg = error {
                complete(errorMsg)
                return
            }
            if let json = data, json["code"].int == 1,let array = json["data"]["records"].array {
                if array.count <= 0 {
                    complete("没有更多了!")
                    return
                }
                for item in array {
                    var bean = InviteLog()
                    bean.invitationLogId = item["invitationLogId"].intValue
                    bean.createTime = item["createTime"].stringValue
                    bean.webUserId = item["webUserId"].intValue
                    bean.phone = item["phone"].stringValue
                    bean.rewardTime = item["rewardTime"].stringValue
                    bean.rewardAmount = item["rewardAmount"].intValue
                    bean.vipPackageId = item["vipPackageId"].intValue
                    self.inviteLogArray.append(bean)
                }
                self.pageIndex = page
                complete(nil)
            }else{
                complete("数据解析错误")
            }
        }
    }
    
}
