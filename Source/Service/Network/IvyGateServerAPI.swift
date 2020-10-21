//
//  RebateServerAPI.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

extension Data {
    private static let hexAlphabet = "0123456789abcdef".unicodeScalars.map { $0 }
    
    public func toHexString() -> String {
        return String(self.reduce(into: "".unicodeScalars, { (result, value) in
            result.append(Data.hexAlphabet[Int(value/16)])
            result.append(Data.hexAlphabet[Int(value%16)])
        }))
    }
}

typealias APIHandler = (_ json:JSON?,_ error:String?)->Void

class IvyGateServerAPI {

    static let shared = IvyGateServerAPI()
//    测试环境
//    var server:String = "http://47.103.136.99:8081"
//    线上环境
    var server:String = "http://api.ivygate.vip"
    
    var token:String = ""
    
    private var httpTasks:[URLSessionTask] = []
    
    private func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
    
    private func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if CFBooleanGetTypeID() == CFGetTypeID(value) {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private func post(_ url:URL,parameters:[String:Any]?,timeout:TimeInterval = 15,complete:@escaping (Data?, URLResponse?, Error?)->Void){
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)
        request.httpMethod = "POST"
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        if let pars = parameters {
            guard let data = query(pars).data(using: .utf8, allowLossyConversion: false) else {
                let error = NSError(domain: "Parameter format error,covert to data failed.", code: 500, userInfo: nil)
                complete(nil, nil,error)
                return
            }
            request.httpBody = data
        }
        
        if token.count > 0 {
            request.setValue(token, forHTTPHeaderField: "token")
        }
        request.timeoutInterval = 10
        
        var dataTask:URLSessionDataTask!
        dataTask = URLSession.shared.dataTask(with: request){ data, response, error in
            
            #if DEBUG
            print("\n======================begin====================")
            print("http request: \(request)")
            print("http header: \n \(String(describing: request.allHTTPHeaderFields))")
            print("http parameters:\(String(describing: parameters))")
            #endif
            
            if let index = self.httpTasks.firstIndex(of: dataTask) {
                self.httpTasks.remove(at: index)
            }
            DispatchQueue.main.async {
                complete(data, response, error)
            }
        }
        if dataTask != nil {
            dataTask.resume()
            httpTasks.append(dataTask as URLSessionDataTask)
        }
    }
    
    func httpPost(_ link:String, _ parameters:[String:Any]?, complete:@escaping APIHandler){
        guard let url = URL(string: link) else {
            complete(nil, "Server link covert to url failed.\(link)")
            return
        }
        self.post(url, parameters: parameters) { (data, response, error) in
            guard error == nil else {
                Log.Info(error.debugDescription)
                complete(nil,error.debugDescription)
//                UINoticeDialog.present("无法连接网络，请检查网络是否正常。")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                complete(nil,"Response can not cover to HTTPURLResponse..")
                return
            }
            let status = response.statusCode
//            guard status == 200 else {
//                UINoticeDialog.present("服务器异常，请稍候再试！(\(status))")
//                complete(nil,error.debugDescription)
//                return
//            }
            guard let jsonData = data else {
                complete(nil, "Response data is nil..")
                return
            }
            #if DEBUG
            print("http response len:\(jsonData.count)")
            if let string = String(data: jsonData, encoding: .utf8) {
                print("http response:")
                print(string)
                print("======================end====================")
            }else{
                Log.Info("Http post response data error. Can not covert data to string! Data hex :\n \(jsonData.toHexString())")
            }
            #endif
            do {
                let json = try JSON(data:jsonData)
                if json["code"].intValue == -1 {
                    NavigationController.shared.userTokenDidInvalid()
                    return
                }
                complete(json,nil)
            } catch let error as NSError {
                #if DEBUG
                print(error)
                #endif
                complete(nil, "Convert data to json throws..")
            }
        }
    }

    func verInfo(_ version:String, complete:@escaping(JSON?, String?)->Void){
        let link = server+"/api/app_code/get_code"
        let parameters:[String:Any] = ["version":version]
        self.httpPost(link, parameters,complete: complete)
    }
    
    func smsCode(_ phoneNumber:String, complete:@escaping(JSON?, String?)->Void){
        let link = server+"/api/user/get_mobile_code"
        let parameters:[String:Any] = ["mobile":phoneNumber]
        self.httpPost(link, parameters,complete: complete)
    }
    
    func login(_ mobile:String,_ verifyCode:String,complete:@escaping APIHandler ){
        let link = server+"/api/user/mobile_code_login"
        let parameters:[String:Any] = ["mobile":mobile, "verifyCode": verifyCode ]
        self.httpPost(link, parameters) { (res, error) in
            if let json = res ,json["code"] == 1 ,let token = json["token"].string {
                self.token = token
            }
            complete(res,error)
        }
    }
    
    func logout(mobile:String,complete:@escaping APIHandler){
        let link = server+"/api/user/logout"
        let parameters:[String:Any] = ["mobile":mobile]
        self.httpPost(link, parameters,complete: complete)
    }
    
    func userInfo(_ userID:Int, complete:@escaping APIHandler ){
        let link = server+"/api/user/get_user_by_id"
        let parameters:[String:Any] = ["webUserId":userID]
        self.httpPost(link, parameters,complete: complete)
    }
    //用户协议
    func userProtocl(complete:@escaping APIHandler ){
        let link = server+"/api/system_set/get_user_explain"
        self.httpPost(link, nil,complete: complete)
        
//        {"code":1,"msg":"获取成功","time":1557328135105,"token":"","data":"123123123"}
//        {"code":-1,"msg":"token失效,请重新登录","time":1557237498381,"token":"","data":""}
    }
    
    //会员服务说明
    func vipProtocl(complete:@escaping APIHandler ){
        let link = server+"/api/system_set/get_vip_explain"
        self.httpPost(link, nil,complete: complete)
    }
    
    func siteList(complete:@escaping APIHandler ){
        let link = server+"/api/web_site/get_list"
        self.httpPost(link, nil,complete: complete)
//    {"code":1,"msg":"获取成功","time":1557328355939,"token":"","data":[{"webSiteId":15,"webSiteName":"xx教育网","webSiteLogo":"uploaded/deae2fc9-e568-463a-9c30-e33d9712867d.png","webSiteLink":"www.baidu.com","webSiteDetail":""}]}
//
//        {"code":-1,"msg":"token失效,请重新登录","time":1557237498381,"token":"","data":""}
    }
    
    func packageList(complete:@escaping APIHandler){
        let link = server+"/api/vip_package/get_list"
        self.httpPost(link, nil,complete: complete)
       
//    {"code":1,"msg":"获取成功","time":1557329213440,"token":"","data":[{"vipPackageId":1,"vipPackageName":"包年","vipPackageTime":31536000,"vipPackagePrice":99.0,"vipPackageStatus":1,"vipPackageNumber":1,"vipPackageUnit":31536000},{"vipPackageId":2,"vipPackageName":"套餐A","vipPackageTime":2592000,"vipPackagePrice":9.9,"vipPackageStatus":1,"vipPackageNumber":1,"vipPackageUnit":2592000}]}
//
//        {"code":-1,"msg":"token失效,请重新登录","time":1557237498381,"token":"","data":""}
    }
    
    func packageDetail(packageID:Int, complete:@escaping APIHandler){
        let link = server+"/api/vip_package/get_package_by_id"
        let parameters:[String:Any] = ["vipPackageId":packageID]
        self.httpPost(link, parameters,complete: complete)
//    {"code":1,"msg":"获取成功","time":1557329213440,"token":"","data":{"vipPackageId":1,"vipPackageName":"包年","vipPackageTime":31536000,"vipPackagePrice":99.0,"vipPackageStatus":1,"vipPackageNumber":1,"vipPackageUnit":31536000}}
//
//        {"code":-1,"msg":"token失效,请重新登录","time":1557237498381,"token":"","data":""}
//        {"code":-2,"msg":"vipPackageId为空","time":1557155284801,"token":"","data":""}
//        {"code":-3,"msg":"获取套餐详情失败","time":1557155284801,"token":"","data":""}
    }
    
    func startProxy(phoneNumber:String, complete:@escaping APIHandler){
        let link = server+"/api/speed_up_log/speed_start"
        let parameters:[String:Any] = ["mobile":phoneNumber]
        self.httpPost(link, parameters,complete: complete)
//        {"code":1"msg":"获取成功","time":1557155284801,"token":"","data":"795800"}
//        {"code":-1,"msg":"token失效,请重新登录","time":1557237498381,"token":"","data":""}
//        {"code":-2,"msg":"加速失败,手机号为空","time":1557155284801,"token":"","data":""}
//        {"code":-3,"msg":"加速失败,手机号对应用户不存在","time":1557155284801,"token":"","data":""}
//        {"code":-4,"msg":"加速失败,用户时长同步失败","time":1557155284801,"token":"","data":""}
    }
    
    func stopProxy(phoneNumber:String, complete:@escaping APIHandler){
        let link = server+"/api/speed_up_log/speed_end"
        let parameters:[String:Any] = ["mobile":phoneNumber]
        self.httpPost(link, parameters,complete: complete)
//        {"code":1"msg":"获取成功","time":1557155284801,"token":"","data":"675800"}
//        {"code":-1,"msg":"token失效,请重新登录","time":1557237498381,"token":"","data":""}
//        {"code":-2,"msg":"加速停止失败,手机号为空","time":1557155284801,"token":"","data":""}
//        {"code":-4,"msg":"加速停止失败,手机号对应用户不存在","time":1557155284801,"token":"","data":""}
    }
    
    func buyPackage(phoneNumber:String,packageID:Int, complete:@escaping APIHandler){
        let link = server+"/api/vip_card/buy_vip_package"
        let parameters:[String:Any] = ["mobile":phoneNumber, "vipPackageId":packageID]
        self.httpPost(link, parameters,complete: complete)
//        {"code":1"msg":"获取成功","time":1557155284801,"token":"","data":"675800"}
//        {"code":-1,"msg":"token失效,请重新登录","time":1557237498381,"token":"","data":""}
//        {"code":-2,"msg":"购买失败,手机号为空","time":1557155284801,"data":""}
//        {"code":-3,"msg":"购买失败,套餐ID为空","time":1557155284801,"token":"","data":""}
//        {"code":-4,"msg":"购买失败,手机号对应用户不存在","time":1557155284801,"token":"","data":""}
//        {"code":-5,"msg":"购买失败,套餐ID为空","time":1557155284801,"token":"","data":""}
//        {"code":-6,"msg":"购买失败,套餐不可用","time":1557155284801,"token":"","data":""}
    }
    
    func exchangeCode(phoneNumber:String,code:String, complete:@escaping APIHandler){
        let link = server+"/api/vip_card/vip_card_exchange"
        let parameters:[String:Any] = ["mobile":phoneNumber, "vipCardCode":code]
        self.httpPost(link, parameters,complete: complete)
//        {"code":1"msg":"获取成功","time":1557155284801,"token":"","data":"675800"}
//        {"code":-1,"msg":"token失效,请重新登录","time":1557237498381,"token":"","data":""}
//        {"code":-2,"msg":"时长码兑换失败,手机号为空","time":1557155284801,"token":"","data":""}
//        {"code":-3,"msg":"时长码兑换失败,时长码为空","time":1557155284801,"token":"","data":""}
//        {"code":-4,"msg":"时长码兑换失败,手机号对应用户不存在","time":1557155284801,"token":"","data":""}
//        {"code":-5,"msg":"时长码兑换失败,时长码不存在","time":1557155284801,"token":"","data":""}
//        {"code":-6,"msg":"时长码兑换失败,时长码禁用或已兑换","time":1557155284801,"token":"","data":""}
    }
    
    func checkApplePay(phone:String,pID:String,state:String,tID:String,receipt:String, complete:@escaping APIHandler){
        let link = server+"/api/purchase_identifier_log/identifier"
        let parameters:[String:Any] = ["mobile":phone,
                                       "receipt":receipt,
                                       "transactionIdentifier":tID,
                                       "productIdentifier":pID,
                                       "state":state,
        ]
        self.httpPost(link, parameters,complete: complete)
    }
    
//    我的邀请列表
    func myInviteList(phone:String,page:Int,limit:Int, complete:@escaping APIHandler){
        let link = server+"/api/invitation_log/get_invitation_logs"
        let parameters:[String:Any] = ["mobile":phone,
                                       "page":page,
                                       "limit":limit
        ]
        self.httpPost(link, parameters,complete: complete)
    }
    
//    我的奖励列表
    func myRewardList(phoneNumber:String, complete:@escaping APIHandler) {
        
    }
    
//    充值记录
    func myRechargeList(phone:String,page:Int,limit:Int, complete:@escaping APIHandler){
        let link = server+"/api/recharge_log/get_recharge_logs"
        let parameters:[String:Any] = ["mobile":phone,
                                       "page":page,
                                       "limit":limit
        ]
        self.httpPost(link, parameters,complete: complete)
        
    }
//    提现金额列表
    func withdrawList( complete:@escaping APIHandler ){
        let link = server+"/api/recharge_tag/get_recharge_tags"
        let parameters:[String:Any] = [:]
        self.httpPost(link, parameters,complete: complete)
    }
//    提现
    func orderWithdraw(phone:String,rechargeTagId:Int, complete:@escaping APIHandler){

        let link = server+"/api/recharge_log/recharge_apply"
        let parameters:[String:Any] = ["mobile":phone,
                                       "rechargeTagId":rechargeTagId
        ]
        self.httpPost(link, parameters,complete: complete)
    }
    
//    规则文字列表
    func ruleList(complete:@escaping APIHandler){
//        let link = server+"/api/system_set/get_invite_explain"
        let link = server+"/api/invitation_rule/get_invitation_rules"
        let parameters:[String:Any] = [:]
        self.httpPost(link, parameters,complete: complete)
    }
    
//    规则说明链接
    func ruleDetailLink(complete:@escaping APIHandler){
        let link = server+"/api/system_set/get_invite_explain"
        let parameters:[String:Any] = [:]
        self.httpPost(link, parameters,complete: complete)
    }
    
//    意见反馈
    func submitFeedback(phone:String,text:String,imageStrings:String?, complete:@escaping APIHandler){
        let link = server+"/api/question/create_question"
        var parameters:[String:Any] = ["mobile":phone,
                                       "questionContent":text
        ]
        if imageStrings != nil {
            parameters["questionImgs"] = imageStrings
        }
        self.httpPost(link, parameters,complete: complete)
    }
    
    func advertInfo(complete:@escaping APIHandler){
        let link = server+"/api/advert/get_advert"
        let parameters:[String:Any] = [:]
        self.httpPost(link, parameters,complete: complete)
    }
    
    
    // mark : 验证原来的手机号
    func verficateOldPhone(phone:String , verfyCode:String , complete:@escaping APIHandler){
        let link = server + "/api/user/verifyOldMobile"
        let parameters:[String:Any] = ["mobile":phone , "verifyCode":verfyCode]
        self.httpPost(link, parameters, complete: complete)
    }
   

    // mark : 验证新的手机号
    func updateNewPhone(phone:String , verfyCode:String , complete:@escaping APIHandler) {
        let link = server + "/api/user/changeNewMobile"
        let parameters:[String:Any] = ["mobile":phone , "verifyCode":verfyCode]
        self.httpPost(link, parameters, complete: complete)
        
    }
    
    // mark :上传多张图片 ,/api/file_upload/upload_imgs
    func uploadImages(params:[String:String]? , images:[UIImage] ,compelte: @escaping APIHandler) {
        var imageDataArray = [Data]()
        var imageNameArray = [String]()
        for i in 0 ..< images.count {
            let item = images[i]
            let imageName = String.init(describing: Date()) + "\(i).png"
            imageDataArray.append(item.jpegData(compressionQuality: 0.1)!)
            imageNameArray.append(imageName)
        }
        
        var headers: HTTPHeaders = [ "Content-Type": "application/x-www-form-urlencoded;charset=utf-8"]
        if token.count > 0 {
            headers["token"] = token
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for i in 0 ..< imageDataArray.count {
                multipartFormData.append(imageDataArray[i], withName: "file", fileName: imageNameArray[i], mimeType: "image/png")
            }
            
        }, usingThreshold: (5*1024*1024), to: server + "/api/file_upload/upload_imgs", method: .post, headers: headers) { (encodingResult) in
            switch encodingResult {
            case .success(let response , _ , _):
                response.responseJSON { (response) in
                    guard let result = response.result.value else { return }
                    #if DEBUG
                    print("<====upload result \(result) ======>")
                    #endif
                    
                    let success = JSON(result)["code"].int ?? -1
                    if success == 1 {
                        compelte(JSON(result), nil)
                    }else {
                        
                    }
                }
                break
                
            case .failure(_):
                break
                
            }
        }
    }
    
    // mark: 上传图片
    func uploadImage(params:[String:String]? , images:[UIImage] ,compelte: @escaping APIHandler){
        var imageDataArray = [Data]()
        var imageNameArray = [String]()
        for i in 0 ..< images.count {
            let item = images[i]
            let imageName = String.init(describing: Date()) + "\(i).png"
            imageDataArray.append(item.jpegData(compressionQuality: 0.1)!)
            imageNameArray.append(imageName)
        }
        
        var headers: HTTPHeaders = [ "Content-Type": "application/x-www-form-urlencoded;charset=utf-8"]
        if token.count > 0 {
            headers["token"] = token
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for i in 0 ..< imageDataArray.count {
                multipartFormData.append(imageDataArray[i], withName: "file", fileName: imageNameArray[i], mimeType: "image/png")
            }
            
        }, usingThreshold: (5*1024*1024), to: server + "/api/file_upload/upload_img", method: .post, headers: headers) { (encodingResult) in
            switch encodingResult {
            case .success(let response , _ , _):
                response.responseJSON { (response) in
                    guard let result = response.result.value else { return }
                    #if DEBUG
                    print("<====upload result \(result) ======>")
                    #endif
                    
                    let success = JSON(result)["success"].int ?? -1
                    if success == 1 {
                        compelte(JSON(result), nil)
                    }else {
                        
                    }
                }
                break
                
            case .failure(_):
                break
                
            }
        }
    }
    
    //获取系统公告分页信息
    func getNotice(page:Int = 1 , limit:Int = 10,webUserId:Int ,complete:@escaping APIHandler) {
        let link = server + "/api/system_notice/get_system_notices"
        let params:[String:Any] = ["page":page , "limit":limit , "webUserId":webUserId]
        self.httpPost(link, params, complete: complete)
        
    }
    
    //获取系统公告详情
    func getNoticeDescription(systemNoticeUserId:Int , complete:@escaping APIHandler) {
        let link = server + "/api/system_notice/get_system_notice_detil"
        let params : [String:Any] = ["systemNoticeId":systemNoticeUserId]
        self.httpPost(link, params, complete: complete)
    }
    
    //修改状态为已读状态
    func changeNoticeState(systemNoticeUserId:Int , complete:@escaping APIHandler) {
        
        let link = server + "/api/system_notice/update_system_notice_read_status"
        let params : [String : Any] = ["systemNoticeUserId":systemNoticeUserId]
        self.httpPost(link, params, complete: complete)
    }
    
    //删除消息
    func deleteNotice(systemNoticeUserId:Int , complete:@escaping APIHandler) {
        
        let link = server + "/api/system_notice/update_system_notice_delete_status"
         let params : [String : Any] = ["systemNoticeUserId":systemNoticeUserId]
        self.httpPost(link, params, complete: complete)
    }
    
    //修改成全部已读
    func makeNoticesAllread(webUserId:Int , complete:@escaping APIHandler) {
        
        let link = server + "/api/system_notice/update_all_system_notice_read_status"
        let params : [String : Any] = ["webUserId":webUserId]
        self.httpPost(link, params, complete:complete)
        
    }
    
    //删除全部消息
    func deleteAllNotices(webUserId:Int , complete:@escaping APIHandler) {
        
        let link = server + "/api/system_notice/update_all_system_notice_delete_status"
        let params : [String : Any] = ["webUserId":webUserId]
        self.httpPost(link, params, complete: complete)
        
    }
    
    //登录的时候把token，platform，webuserid传给后台
    func uploadPushInfomations(webUserId:Int , token:String ,plateformType:Int , completion:@escaping APIHandler)  {
        
        let link = server + "/api/user/save_devie_token"
        let params : [String : Any] = ["webUserId":webUserId , "devicetoken":token , "plateformType":1]
        self.httpPost(link, params, complete: completion)
    }
    
    
    //判断当前版本是否是最新版本
    func isLastVersion(versionId:String , completion:@escaping APIHandler) {
        let link = server + "/api/app_code/get_last_version"
        let params : [String : Any] = ["version":versionId]
        self.httpPost(link, params, complete: completion)
    }
    
    //生成支付订单
    func generateAnewOrder(vipPackageId:Int , completion:@escaping APIHandler) {
        let link = server + "/api/vip_card/createOrder"
        let params : [String : Any] = ["vipPackageId":vipPackageId]
        self.httpPost(link, params, complete: completion)
    }
    
    //购买套餐
    func buyPackage(vipPackageId:Int , orderNumber:String , completion:@escaping APIHandler) {
        let link = server + "/api/vip_card/payOrder"
        let params : [String : Any] = ["vipPackageId":vipPackageId , "orderNumber":orderNumber]
        self.httpPost(link, params, complete: completion)
    }
    
    //获取验证码图片
    func getSmsImages(type:Int , completion:@escaping APIHandler) {
        
        var typeInte :String = ""
        
        if type == 0 {
        
            typeInte = "blockPuzzle"
        }else {
            typeInte = ""
        }
        let params :[String:Any] = ["captchaType":typeInte]
        
        let link = server + "/api/captcha/get_captcha"
        
        self.httpPost(link, params, complete: completion)
        
    }
    
    
    //验证滑块图片
    func checkSmsImages(type:Int , pointJson:String, token:String ,completion:@escaping APIHandler) {
        var typeInte :String = ""
        
        if type == 0 {
        
            typeInte = "blockPuzzle"
        }else {
            typeInte = ""
        }
        
        let link = server + "/api/captcha/check_captcha"
        let params:[String:Any] = ["captchaType":typeInte , "pointJson":pointJson , "token":token]
        
        self.httpPost(link, params, complete: completion)
        
    }
    
    func strongcheckSmsImages(captchaVerification:String , mobile:String ,completion:@escaping APIHandler) {
        let link = server + "/api/captcha/verify_captcha"
        let params = ["captchaVerification":captchaVerification , "mobile":mobile]
        self.httpPost(link, params, complete: completion)
    }
    
    
}
