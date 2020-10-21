//
//  MyRechargeHeadView.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class MyRechargeHeadView: UIView {

    static let cellHeight:CGFloat = 45
    
    lazy var timeLabel = UILabel()
    lazy var moneyLabel = UILabel()
    lazy var statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(timeLabel)
        self.addSubview(moneyLabel)
        self.addSubview(statusLabel)
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        moneyLabel.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(16)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.height.equalTo(16)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.centerY.equalToSuperview()
        }
        
        self.backgroundColor = UIColor.RGBHex(0x00C97E)
        
        timeLabel.text = "时间"
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        timeLabel.textColor = UIColor.RGBHex(0xffffff)
        
        moneyLabel.text = "金额"
        moneyLabel.textAlignment = .center
        moneyLabel.font = UIFont.systemFont(ofSize: 16)
        moneyLabel.textColor = UIColor.RGBHex(0xffffff)
        
        statusLabel.text = "状态"
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 16)
        statusLabel.textColor = UIColor.RGBHex(0xffffff)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
