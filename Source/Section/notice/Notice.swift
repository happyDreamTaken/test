//
//  Notice.swift
//  IvyGate
//
//  Created by MrFeng on 2019/10/24.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class Notice: NSObject {
    
    var systemNoticeId = 0
    var createTime = ""
    var systemNoticeTitle = ""
    var systemNoticeContent = ""
    var systemNoticeReadStatus = -1   // -1 未读 ， 1 已读
    var systemNoticeDeleteStatus = -1 // -1 未删除，1已删除
    var systemNoticeStatus = 1
    var systemNoticeSubtitle = ""
    override init() {
        super.init()
    }

    
}
