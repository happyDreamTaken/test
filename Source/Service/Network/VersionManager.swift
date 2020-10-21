//
//  VersionManager.swift
//  IvyGate
//
//  Created by tjvs on 2019/10/11.
//  Copyright © 2019 yicheng. All rights reserved.
//

import Foundation
import SwiftyJSON

enum VersionStatus : Int {
    case test = 1000
    case review = 1001
    case release = 1002
    case offline = 1003
}

class VersionManager {
    
    static let shared = VersionManager()
    
    lazy var verStatus:VersionStatus = .review
    
    func requestVersionInfo(){
        var version = "2.0.0"
        if let info = Bundle.main.infoDictionary, let ver = info["CFBundleShortVersionString"] as? String {
            version = ver
        }
        IvyGateServerAPI.shared.verInfo(version) { (response, error) in
            self.parseVersionStatus(response)
        }
        
        
    }
    
    func parseVersionStatus( _ response:JSON? ){
        guard let json = response else { return }
        guard let code = json["code"].int, code == 1 else { return }
        if let address = json["address"].string,let port = json["port"].int {
            VpnManager.server = address
            VpnManager.port = port
        }
        guard let status = json["data"].string else { return }
        switch status {
        case "1000":
            self.verStatus = .test
        case "1002":
            self.verStatus = .release
        case "1003":
            self.verStatus = .offline
            self.getVersionSign()
        default:
            self.verStatus = .review
        }
        let isHideView = (self.verStatus == .review)
        HomeViewController.shared.siteTableView.isHidden = isHideView
        VIPViewController.shared.exchangeView.isHidden = isHideView
    }
    
    
    func getVersionSign() {
        var version = "2.1.0"
        if let info = Bundle.main.infoDictionary, let ver = info["CFBundleShortVersionString"] as? String {
            version = ver
        }
        IvyGateServerAPI.shared.isLastVersion(versionId: version) { (response, error) in
            guard let json = response else { return }
            let code = json["code"].int
            
            switch code {
                case 1 :
                   break
            case 2 :
                UIUpgradeDialog().present()
                default :
                   break
            }
        }
    }
}
