//
//  MyRechargeCell.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class MyRechargeCell: UITableViewCell {

    static let identifier = "MyInviteCell"
    static let cellHeight:CGFloat = 60
    
    lazy var timeLabel = UILabel()
    lazy var moneyLabel = UILabel()
    lazy var statusLabel = UILabel()
    lazy var lineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.clipsToBounds = true
        
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(moneyLabel)
        self.contentView.addSubview(statusLabel)
        self.contentView.addSubview(lineView)
        
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
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(-0.5)
            make.height.equalTo(0.5)
        }
        
        self.contentView.backgroundColor = UIColor.white
        
        timeLabel.text = "2019-07-20"
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 16)
        timeLabel.textColor = UIColor.RGBHex(0x333333)
        
        moneyLabel.text = "20"
        moneyLabel.textAlignment = .center
        moneyLabel.font = UIFont.systemFont(ofSize: 16)
        moneyLabel.textColor = UIColor.RGBHex(0x333333)
        
        statusLabel.text = "待确认"
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 16)
//        statusLabel.textColor = UIColor.RGBHex(0x00C97E)
        statusLabel.textColor = UIColor.RGBHex(0xFA5800)
    
        lineView.backgroundColor = UIColor.RGBHex(0xe3e3e3)
    }
    
    func setStatus(status:Int){
        if status == 1 {
            statusLabel.text = "充值成功"
            statusLabel.textColor = UIColor.RGBHex(0xFA5800)
        }else{
            statusLabel.text = "待确认"
            statusLabel.textColor = UIColor.RGBHex(0x00C97E)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
