//
//  Tencent.swift
//  IvyGate
//
//  Created by tjvs on 2019/9/12.
//  Copyright © 2019 yicheng. All rights reserved.
//

import Foundation


enum TencentShareType:UInt {
    case qq
    case qzone
}

class Tencent : NSObject , TencentSessionDelegate {
    
    func tencentDidLogin() {
        
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        
    }
    
    func tencentDidNotNetWork() {
        
    }
    
    
    static let appKey = "1109934842"
    static let appSecret = "PspVa6E2B5gDqSnp"
    
    static let shared = Tencent(Tencent.appKey)
    
    lazy var tencentOAuth:TencentOAuth = TencentOAuth(appId: Tencent.appKey, andDelegate: self)
    
    init(_ appKey:String) {
        super.init()
        self.tencentOAuth.authShareType = AuthShareType_QQ
    }
    
    func openURL(url:URL) -> Bool{
        return TencentOAuth.handleOpen(url)
    }
    
    func share(link:String,title:String?,detail:String?,thumbImage:UIImage?,to:TencentShareType){
        guard let url = URL(string: link) else {
            return
        }
        var imageData:Data?
        if let image = thumbImage {
            imageData = compressImage(image, toByte: 1024 * 1024)
        }
        let news = QQApiNewsObject(url: url, title: title ?? "", description: detail, previewImageData: imageData, targetContentType: .video)
//        if to == .qzone {
//            news?.cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
//        }
        let request = SendMessageToQQReq(content: news)
        let result:QQApiSendResultCode
//        if to == .qq {
            result = QQApiInterface.send(request)
//        }else{
//            result = QQApiInterface.sendReq(toQZone: request)
//        }
        self.handleSendResult(sendResult: result)
    }
    
    func compressImage(_ image: UIImage, toByte maxLength: Int) -> Data {
        var compression: CGFloat = 1
        var data = image.jpegData(compressionQuality: compression)!
        if data.count <= maxLength {
            return data
        }
        // Compress by size
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = image.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < maxLength { return data }
        
        // Compress by size
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: compression)!
        }
        return data
    }
    
    func handleSendResult(sendResult:QQApiSendResultCode){
        switch sendResult {
        case .EQQAPIAPPNOTREGISTED:
            print("App未注册")
        case .EQQAPIMESSAGECONTENTINVALID:
            print("发送参数错误")
        case .EQQAPIMESSAGECONTENTNULL:
            print("发送参数错误")
        case .EQQAPIMESSAGETYPEINVALID:
            print("发送参数错误")
        case .EQQAPIQQNOTINSTALLED:
            print("未安装手Q")
        case .EQQAPITIMNOTINSTALLED:
            print("未安装TIM")
        case .EQQAPIQQNOTSUPPORTAPI:
            print("API接口不支持")
        case .EQQAPISENDFAILD:
            print("发送失败")
        case .EQQAPIQZONENOTSUPPORTTEXT:
            print("空间分享不支持QQApiTextObject，请使用QQApiImageArrayForQZoneObject分享")
        case .EQQAPIQZONENOTSUPPORTIMAGE:
            print("空间分享不支持QQApiImageObject，请使用QQApiImageArrayForQZoneObject分享")
        case .EQQAPIVERSIONNEEDUPDATE:
            print("当前QQ版本太低，需要更新")
        case .ETIMAPIVERSIONNEEDUPDATE:
            print("当前TIM版本太低，需要更新")
        default:
            print("QQ调用结果: \( sendResult )")
        }
    }
}

extension Tencent : QQApiInterfaceDelegate {
    /**
     处理来至QQ的请求
     */
    func onReq(_ req:QQBaseReq) {
        print("codeboor onReq " + req.description)
    }
    
    /**
     处理来至QQ的响应
     */
    func onResp(_ resp: QQBaseResp!) {
        print("codeboor onResp " + resp.description)
    }
    
    /**
     处理QQ在线状态的回调
     */
    func isOnlineResponse(_ response: [AnyHashable : Any]!) {
        
    }
}
