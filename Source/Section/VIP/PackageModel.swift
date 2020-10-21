//
//  PackageModel.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 tjvs. All rights reserved.
//

import Foundation

class PackageModel {
    var vipPackageId = 0
    var vipPackageName = ""
    var vipPackageTime = 0
    var vipPackagePrice = 0
    var vipPackageStatus = 0
    var vipPackageNumber = 0
    var vipPackageUnit = 0
    var vipPackageBuyId = ""
    var vipPackageOldPrice = ""
    
    var priceText: String {
        return "\(vipPackagePrice)"
    }
    
    var priceHourText: String {
        let hour = vipPackageTime * 24
        var price = 0.00
        if vipPackagePrice > 0 {
            price = Double(vipPackagePrice)/Double(vipPackageTime)
        }
        let text = String(format: "%.2f", price)
        return "\(hour)小时 \(text)/天"
    }
}

