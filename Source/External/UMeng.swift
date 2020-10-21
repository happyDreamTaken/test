//
//  UMeng.swift
//  infomation
//
//  Created by codeboor on 2017/6/27.
//
//

import Foundation
import UserNotifications


enum UMengCountEvent:String {
    //*********************启动页***********************************
    case homepage = "homepage" //首页
}

class UMeng : NSObject{
    
    static let appKey = "5d3ff2463fc195832f000421"
    
    static let channel = "Ivygate"
    
    static let aliasyType = "ivygate"
    
    static let shared = UMeng(UMeng.appKey,channel:UMeng.channel)
    
    init(_ appKey:String,channel:String) {
        super.init()
        UMConfigure.initWithAppkey(appKey, channel: channel)
        MobClick.setScenarioType(.E_UM_NORMAL)
        #if DEBUG
            UMConfigure.setLogEnabled(true)
        #else
            UMConfigure.setLogEnabled(false)
        #endif
    }
    
    func count(event:UMengCountEvent) {
        MobClick.event(event.rawValue)
    }
    
    func count(event:UMengCountEvent,label:String) {
        MobClick.event(event.rawValue,label:label)
    }
    
    func count(event:String,label:String) {
        MobClick.event(event,label:label)
    }
    
    func registPush() {
        
    }
}
