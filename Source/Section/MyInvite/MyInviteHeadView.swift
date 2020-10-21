//
//  MyInviteHeadView.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class MyInviteHeadView: UIView {

    static let cellHeight:CGFloat = 126
    
    lazy var contentView = UIView()
    lazy var titleLabel = UILabel()
    lazy var valueLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(13)
            make.bottom.equalTo(-13)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(19)
            make.height.equalTo(12)
            make.width.equalToSuperview()
            make.left.equalTo(0)
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(49)
            make.height.equalTo(27)
            make.right.equalTo(0)
            make.left.equalTo(0)
        }
        
        self.backgroundColor = UIColor.white
        
        contentView.backgroundColor = UIColor.RGBHex(0x00C97E)
        contentView.layer.cornerRadius = 5
        
        titleLabel.text = "已邀请人数"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = UIColor.RGBHex(0xffffff)
        
        valueLabel.textAlignment = .center

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
