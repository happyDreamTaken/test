//
//  UserInfoView.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class UserInfoView: UIView {

    lazy var backgroundView = UIImageView()
    lazy var titleLabel = UILabel()
    lazy var nameLabel = UILabel()
    lazy var timeLabel = UILabel()
    lazy var packageLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        addSubview(backgroundView)
        addSubview(titleLabel)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(packageLabel)
        
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(14)
//            make.top.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
            make.width.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(43)
            make.height.equalTo(18)
            make.left.equalTo(43)
            make.width.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(27)
            make.height.equalTo(18)
            make.left.equalTo(43)
            make.width.equalToSuperview()
        }
        
        packageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(27)
            make.height.equalTo(18)
            make.left.equalTo(169)
            make.width.equalToSuperview()
        }
        
        backgroundView.image = UIImage(named: "vip_background")
        
        titleLabel.text = "我的会员"
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.RGBHex(0xffffff)
        titleLabel.textAlignment = .center
        
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        nameLabel.textColor = UIColor.RGBHex(0xffffff)
        
        timeLabel.text = "您的使用时长至:"
        timeLabel.font = UIFont.systemFont(ofSize: 15)
        timeLabel.textColor = UIColor.RGBHex(0xffffff)
        
        packageLabel.font = UIFont.systemFont(ofSize: 18)
        packageLabel.textColor = UIColor.RGBHex(0xffffff)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
