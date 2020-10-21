//
//  VersionCell.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class VersionCell: UITableViewCell {

    static let reuseIdentifier = "VersionCell"
    static let cellHeight:CGFloat = 52
    
    lazy var titleLabel = UILabel()
    lazy var versionLabel = UILabel()
    lazy var lineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.clipsToBounds = true
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(versionLabel)
        self.contentView.addSubview(lineView)
        
        versionLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-22)
            make.width.equalTo(60)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.height.equalTo(18)
            make.right.equalTo(versionLabel.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.bottom.equalTo(-0.5)
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        self.contentView.backgroundColor = UIColor.white
        
        titleLabel.text = "当前版本"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor.RGBHex(0x333333)
        
        versionLabel.text = "v2.5.1"
        versionLabel.textAlignment = .right
        versionLabel.font = UIFont.systemFont(ofSize: 17)
        versionLabel.textColor = UIColor.RGBHex(0x333333)
        
        lineView.backgroundColor = UIColor.RGBHex(0xe3e3e3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
