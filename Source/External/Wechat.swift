//
//  Wechat.swift
//  IvyGate
//
//  Created by tjvs on 2019/9/12.
//  Copyright © 2019 yicheng. All rights reserved.
//

import Foundation

enum WechatShareType:UInt {
    case friend
    case circle
    case favorite
}

class Wechat : NSObject {
    
    static let appKey = "wxc8cbbdcffca6b3da"
    static let shared = Wechat(appKey)
    
    init(_ appKey:String){
        WXApi.registerApp(appKey)
    }
    
    func openURL(url:URL) -> Bool{
        return WXApi.handleOpen(url, delegate: self)
    }
    
    //分享web页面
    func share(link:String,title:String?,detail:String?,thumbImage:UIImage?,to:WechatShareType){
        let scene = self.scene(to)
        let mediaObject = WXWebpageObject()
        mediaObject.webpageUrl = link
        
        let message = WXMediaMessage()
        if let titleText = title {
            message.title = titleText
        }
        if let detailText = detail {
            message.description = detailText
        }
        if let image = thumbImage {
            message.setThumbImage(image)
        }
        message.mediaObject = mediaObject
        share(message, to: scene)
    }
    
    fileprivate func share(_ media:WXMediaMessage,to scene:WXScene){
        let request = SendMessageToWXReq()
        request.bText = false
        request.message = media
        request.scene = Int32(scene.rawValue)
        WXApi.send(request)
    }
    
    fileprivate func scene(_ type:WechatShareType) ->WXScene {
        switch type {
        case .friend:
            return WXSceneSession
        case .circle:
            return WXSceneTimeline
        case .favorite:
            return WXSceneFavorite
        }
    }
    
}

extension Wechat : WXApiDelegate {
    
    func onReq(_ req: BaseReq) {
        
    }
    
    func onResp(_ resp: BaseResp) {
        //分享响应
        if let shareResp = resp as? SendMessageToWXResp {
            onShareResponse(shareResp)
            return
        }
    }
    
    //分享结果响应
    func onShareResponse(_ shareResp: SendMessageToWXResp){
        let errCode = shareResp.errCode
        switch errCode {
        case WXSuccess.rawValue:
            break
        case WXErrCodeCommon.rawValue:
            /**< 普通错误类型    */
            break
        case WXErrCodeUserCancel.rawValue:
            /**< 用户点击取消并返回    */
            break
        case WXErrCodeUserCancel.rawValue:
            break
        case WXErrCodeSentFail.rawValue:
            /**< 发送失败    */
            break
        case WXErrCodeAuthDeny.rawValue:
            /**< 授权失败    */
            break
        case WXErrCodeUnsupport.rawValue:
            /**< 微信不支持    */
            break
        default:
            break
        }
    }
}
