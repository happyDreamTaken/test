//
//  RechargeManager.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import Foundation

struct RechargeLog {
//    rechargeLogId    Integer    充值ID    3
//    createTime    DateTime    创建时间    2019-06-06T14:04:05
//    rechangePhone    String    充值电话电话    13693483720
//    rechargeAmount    Integer    充值金额    2019-06-06T14:04:05
//    rechargeLogTime    DateTime    充值确认时间    2019-06-06T14:04:05
//    rechargeStatus    Integer    充值状态(-1:未充值,1:已充值)    -1
    var rechargeLogId = 0
    var createTime = ""
    var rechangePhone = ""
    var rechargeAmount = 0
    var rechargeLogTime = ""
    var rechargeStatus = 0
}

class RechargeManager {
    
    static let shared = RechargeManager()
    lazy var rechargeLogArray:[RechargeLog] = []
    var pageIndex = 1
    let pageLimit = 20
    
    func update( complete:@escaping ( (_ error:String?)->Void ) ){
        let phone = User.shared.phone
        IvyGateServerAPI.shared.myRechargeList(phone: phone, page: 1, limit: pageLimit) { (data, error) in
            if let errorMsg = error {
                complete(errorMsg)
                return
            }
            if let json = data, json["code"].int == 1,let array = json["data"]["records"].array  {
                self.rechargeLogArray.removeAll()
                self.pageIndex = 1
                for item in array {
                    var bean = RechargeLog()
                    bean.rechargeLogId = item["rechargeLogId"].intValue
                    bean.createTime = item["createTime"].stringValue
                    bean.rechangePhone = item["rechangePhone"].stringValue
                    bean.rechargeAmount = item["rechargeAmount"].intValue
                    bean.rechargeLogTime = item["rechargeLogTime"].stringValue
                    bean.rechargeStatus = item["rechargeStatus"].intValue
                    self.rechargeLogArray.append(bean)
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
                    var bean = RechargeLog()
                    bean.rechargeLogId = item["rechargeLogId"].intValue
                    bean.createTime = item["createTime"].stringValue
                    bean.rechangePhone = item["rechangePhone"].stringValue
                    bean.rechargeAmount = item["rechargeAmount"].intValue
                    bean.rechargeLogTime = item["rechargeLogTime"].stringValue
                    bean.rechargeStatus = item["rechargeStatus"].intValue
                    self.rechargeLogArray.append(bean)
                }
                self.pageIndex = page
                complete(nil)
            }else{
                complete("数据解析错误")
            }
        }
    }
    
}
