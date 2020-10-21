//
//  UIConfirmDialog.swift
//  IvyGate
//
//  Created by tjvs on 2019/10/10.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit
import MJRefresh
import SnapKit

class MJRefreshHeaderView: MJRefreshHeader {

    
    var label:UILabel!
    var loading:UIActivityIndicatorView!
    
    override func prepare() {
        
        super.prepare()
        
        self.mj_h = 44
        self.backgroundColor = UIColor.white //RGBHex(0xF5F5F5)
        let loading = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        self.addSubview(loading)
        self.loading = loading
        self.loading.tintColor = UIColor.RGBHex(0x888888)
        
        let label = UILabel()
        label.textColor = UIColor.RGBHex(0x999999)
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        self.addSubview(label)
        self.label = label
        self.label.textColor = UIColor.RGBHex(0x999999)
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        self.loading.snp.makeConstraints { (make) in
            make.top.equalTo(2)
            make.centerX.equalTo(self)
        }
        
        self.label.snp.makeConstraints { (make) in
            make.top.equalTo(self.loading.snp.bottom).offset(6)
            make.centerX.equalTo(self)
        }
    }
    
    override var state: MJRefreshState{
        didSet{
            switch state {
            case .idle:
                self.label.text = "准备刷新"
                self.loading.stopAnimating()
            case .pulling:
                self.label.text = "松开立即刷新"
                self.loading.startAnimating()
            case .refreshing:
                self.label.text = "刷新中"
                self.loading.startAnimating()
            default:
                break
            }
        }
    }

}
