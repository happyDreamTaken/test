//
//  RewardManager.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import Foundation

struct WithdrawBean {
    var rechargeTagId = 0
    var rechargeAmount = 0
    var rechargeDescrible = ""
    var sort = 0
}

class RewardManager {
    
    static let shared = RewardManager()
    
    var withdrawArray:[WithdrawBean] = []
    
    func updateWithdrawList(complete:@escaping ( (_ error:String?)->Void )){
        IvyGateServerAPI.shared.withdrawList(){ (data, error) in
            if let errorMsg = error {
                complete(errorMsg)
                return
            }
            if let json = data, json["code"].int == 1,let array = json["data"].array {
                self.withdrawArray.removeAll()
                for item in array {
                    var bean = WithdrawBean()
                    bean.rechargeTagId = item["rechargeTagId"].intValue
                    bean.rechargeAmount = item["rechargeAmount"].intValue
                    bean.rechargeDescrible = item["rechargeDescrible"].stringValue
                    bean.sort = item["sort"].intValue
                    self.withdrawArray.append(bean)
                }
                complete(nil)
            }else{
                complete("数据解析错误")
            }
        }
    }
    
    func doReward(rechargeTagId:Int,complete:@escaping ( (_ error:String?)->Void )){
        let phone = User.shared.phone
        IvyGateServerAPI.shared.orderWithdraw(phone: phone, rechargeTagId: rechargeTagId) { (data, error) in
            if let errMsg = error {
                complete(errMsg)
                return
            }
            if let json = data {
                if json["code"].int == 1 {
                    complete(nil)
                }else if json["code"].int == -4 {
                    complete( "抱歉，您的账户剩余奖励金不足，请重新选择需要充值的金额？")
                }else{
                    complete( json["msg"].string ?? "操作失败")
                }
            }
        }
    }
    
}
