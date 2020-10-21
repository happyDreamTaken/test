//
//  MyInviteCell.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class MyInviteCell: UITableViewCell {

    static let reuseIdentifier = "MyInviteCell"
    static let cellHeight:CGFloat = 68
    
    lazy var headImageView = UIImageView()
    lazy var titleLabel = UILabel()
    lazy var timeLabel = UILabel()
    lazy var lineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.clipsToBounds = true
        
        self.contentView.addSubview(headImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(lineView)
        
        headImageView.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.width.equalTo(38)
            make.height.equalTo(38)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(headImageView.snp.right).offset(13)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(13)
            make.centerY.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.height.equalTo(13)
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.right.equalTo(-13)
            make.bottom.equalTo(-0.5)
            make.height.equalTo(0.5)
        }
        
        self.contentView.backgroundColor = UIColor.white
        
        headImageView.image = UIImage(named: "head_image")
    
        titleLabel.text = "133*****3102"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = UIColor.RGBHex(0x333333)
        
        timeLabel.text = "2019-07-20"
        timeLabel.textAlignment = .right
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        timeLabel.textColor = UIColor.RGBHex(0x333333)
        
        lineView.backgroundColor = UIColor.RGBHex(0xe3e3e3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
