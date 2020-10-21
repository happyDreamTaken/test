//
//  IvyInPurchSafeManager.swift
//  IvyGate
//
//  Created by MrFeng on 2019/10/25.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class IvyInPurchSafeManager: NSObject {
    
    static let safeManager = IvyInPurchSafeManager.init()
    
    let  maxTimes = 5
    var currentTime = 0
    var timer :Timer?
    
    var isAddInsubmitPackageOrder : Bool? {
       didSet {
            UserDefaults.standard.setValue(oldValue, forKey: "isAddInsubmitPackageOrder")
        }
    }
    
    var isPackageOrderback:Bool? {
        didSet {
            UserDefaults.standard.setValue(oldValue, forKey: "isPackageOrderback")
        }
        
    }
    
    var isQueryOrder : Bool? {
        
        didSet {
            UserDefaults.standard.setValue(oldValue, forKey: "isQueryOrder")
        }
        
    }
    
    var isQueryOrderback :Bool? {
        didSet {
            UserDefaults.standard.setValue(oldValue, forKey: "isQueryOrderback")
        }
    }
    
    private override init() {
        super.init()
        
    }
    
    //存储产品ID , 状态 , transactionId , receipt信息(用户支付行为已经确认，等待苹果服务端反馈信息过程中)
    func storeProductId(productId:String , tState:Int , transactionId:String , receipt:String) {
        
        isAddInsubmitPackageOrder = false
        isPackageOrderback = false
        isQueryOrderback = false
        isQueryOrder = false
        if (UserDefaults.standard.value(forKey: "productIdentifier") != nil) {
            self.clearProduct()
        }
        UserDefaults.standard.set(productId, forKey: "productIdentifier")
        UserDefaults.standard.set(tState, forKey: "tstate")
        UserDefaults.standard.set(transactionId, forKey: "transactionId")
        UserDefaults.standard.set(receipt, forKey: "receipt")
        UserDefaults.standard.synchronize()
    }
    
    //当product为付款，并且已经接受到服务器的验证信息则清除当前产品Id
    func clearProduct() {
        let boolState:Int = UserDefaults.standard.integer(forKey: "tstate")
        //状态为已付款的情况
        if boolState == 1 {
            UserDefaults.standard.removeObject(forKey: "productIdentifier")
            UserDefaults.standard.removeObject(forKey: "receipt")
            UserDefaults.standard.removeObject(forKey: "transactionId")
            UserDefaults.standard.removeObject(forKey: "tstate")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    //检验是否有存储内容
    func check() {
        let boolState:Int = UserDefaults.standard.integer(forKey: "tstate")
        if boolState == 1 {
            
            let pID:String =  UserDefaults.standard.value(forKey: "productIdentifier") as! String
            let receipt:String =  UserDefaults.standard.value(forKey: "receipt") as! String
            let transactionId:String =  UserDefaults.standard.value(forKey: "transactionId") as! String
            let tstate:Int =  UserDefaults.standard.value(forKey: "tstate") as! Int
            
            self.queryOrder(pID: pID, state: String.init(format: "%d", tstate), tID: transactionId, receipt: receipt)
        }
    }
    
    //如果付款后没有收到返回信息，那么每隔5秒向苹果服务端发送再次请求认证
    func askForCurrentProduct(productId:String) {
        
        //1,启动定时器5秒执行一次
        self.timer! = Timer.init(timeInterval: 5, target: self, selector: #selector(doLoop), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    
    //如果存在订单已经付款，而后台未清除消息，或未立即清除
    func debugWithInPurchaseInfo() {
        let boolState:Int = UserDefaults.standard.integer(forKey: "tstate")
        
        var stringEnd = ""
        var stringBottom = ""
        
        if
            UserDefaults.standard.bool(forKey: "isQueryOrder") == true  {
            if UserDefaults.standard.bool(forKey: "isQueryOrderback") == false {
               stringEnd = "5 . description : 走了isQueryOrder方法,但是没有走isQueryOrderback方法 \n"
            }else {
                stringEnd = "5 . description : 走了isQueryOrder方法,同时走isQueryOrderback方法 \n"
            }
        }else {
            stringEnd = "5 . app未执行到当前行就被杀死了 \n"
        }
        
        if  UserDefaults.standard.bool(forKey: "isAddInsubmitPackageOrder") == true {
            if UserDefaults.standard.bool(forKey: "isPackageOrderback") == false {
                stringBottom = "6  . description : 走了isAddInsubmitPackageOrder方法,但是没有走isAddInsubmitPackageOrderBack方法 \n"
            }else {
                stringBottom = "6  . description : 走了isAddInsubmitPackageOrder方法,同时走isAddInsubmitPackageOrderBack方法 \n"
            }
        }else {
            stringBottom = "6 . app未执行到当前行被杀死了 \n"
        }
        
        if boolState == 1 {
            let pID:String =  UserDefaults.standard.value(forKey: "productIdentifier") as! String
            let receipt:String =  UserDefaults.standard.value(forKey: "receipt") as! String
            let transactionId:String =  UserDefaults.standard.value(forKey: "transactionId") as! String
            let tstate:Int =  UserDefaults.standard.value(forKey: "tstate") as! Int
            
            //存储到文件pid.txt当中
            let filePath = NSHomeDirectory() + "/Documents/\(pID).txt"
            
            if (FileManager.default.contents(atPath: filePath) != nil) {
                try! FileManager.default.removeItem(atPath: filePath)
            }
            
            let content = "1 . PID: \(pID) \n 2 . receipt : \(receipt) \n 3 . transactionId : \(transactionId) \n 4 . 已付款未给货订单  \n \(stringEnd) \(stringBottom)"
            
            try! content.write(toFile: filePath, atomically: true, encoding: .utf8)
            
        }
    }
    
    
    //如果此问题已经解决，或有新的订单则
    func fileRemovePID(pID:String) {
        
          let filePath = NSHomeDirectory() + "/Documents/\(pID).txt"
          if filePath.contains(pID) {
           try! FileManager.default.removeItem(atPath: filePath)
          }
    }
    
    
    //销毁定时器
    func invalidTimer() {
        if (self.timer != nil)
                {
                    if self.timer!.isValid
                    {
                        self.timer!.invalidate();
                        self.timer = nil;
                    }
                }
    }
    
     func setTestData() {
        self.storeProductId(productId: "123456", tState: 1, transactionId: "ewf4ewfwffw", receipt: "helload")
    }
    

}

extension IvyInPurchSafeManager {
    
    
    @objc fileprivate func doLoop() {
        
        self.currentTime += 1
        
        if self.currentTime <= maxTimes {
            self.check()
        }else {
            self.invalidTimer()
        }
        
    }
    
    private func queryOrder(pID:String,state:String,tID:String,receipt:String){
        let phone = User.shared.phone
        IvyGateServerAPI.shared.checkApplePay(phone:phone,
                                              pID: pID,
                                              state: state,
                                              tID: tID,
                                              receipt: receipt) { (respose, error) in
                                                
                                                if error == nil {
                                                    IvyInPurchSafeManager.safeManager.clearProduct()
                                                   
                                                  self.invalidTimer()
                                                  
                                                }
                                                
                                                
        }
        
    }
     
}

extension IvyInPurchSafeManager {
    
   //发送验证信息给服务端进行二次验证
    func verifyOrder(pID:String,state:String,tID:String,receipt:String , completion:@escaping()->Void){
        IvyGateServerAPI.shared.checkApplePay(phone:User.shared.phone,
                                                   pID: pID,
                                                   state: state,
                                                   tID: tID,
                                                   receipt: receipt) { (respose, error) in
                                                      
                                                     if error == nil {
                                                        self.submitPackageOrder()
                                                        
                                                    }
                                                    
                            completion()
        }
    }
   
   //全局处理订单消息，使得消息不至于由于延迟而未监听到
    func listenOrder() {
        SwiftyStoreKit.completeTransactions(atomically: true) { (purchases) in
                for purchase in purchases {
                    if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                        
                                let pID = purchase.productId
                                let tState = purchase.transaction.transactionState
                                let tID = purchase.transaction.transactionIdentifier ?? ""
                                if let receiptData = SwiftyStoreKit.localReceiptData {
                                    let receipt = receiptData.base64EncodedString(options: [])
                                    self.verifyOrder(pID: pID, state: "\(tState)", tID: tID, receipt: receipt) {
                                        if purchase.needsFinishTransaction {
                                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                                        }
                                    }
                                }else {
                                    self.verifyOrder(pID: pID, state: "\(tState)", tID: tID, receipt: "") {
                                        if purchase.needsFinishTransaction {
                                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                                        }
                                    }
                                }
                               print("purchased: \(purchase)")
                        
                        
                    }else {
                        
                        
                    }
            }
        }
    }
    
    
    func submitPackageOrder(){
           
        let packageId = UserDefaults.standard.value(forKey: "vipPackageId")
               let orderNumber = UserDefaults.standard.value(forKey: "orderNumber")
        
        if packageId == nil || orderNumber == nil{
            return
        }
               
        IvyGateServerAPI.shared.buyPackage(vipPackageId: packageId as! Int, orderNumber: orderNumber as! String) { (response, error) in
               guard let json = response else {
                            return
        }
        guard let code = json["code"].int else {
                return
        }
                   
        UserDefaults.standard.removeObject(forKey: "packageId")
        UserDefaults.standard.removeObject(forKey: "orderNumber")
                   
        if code == 1 {
                if let vipTime = json["data"]["vipTime"].string {
                    User.shared.vipTime = vipTime
                }
                let vipCardTime = json["data"]["vipCardTime"].intValue
                UINoticeDialog.present("恭喜，套餐绑定成功！\n您已获得\(vipCardTime)天的体验时长")
            }else {
                if code == -5 {
                    UINoticeDialog.present("抱歉，充值续费失败！\n请重新尝试")
                }
            }
                   
        }
        
    }
    
}
