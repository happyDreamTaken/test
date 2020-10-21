//
//  WelfareCell.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class WelfareCell: UITableViewCell {

    static let reuseIdentifier = "WelfareCell"
    static let cellHeight:CGFloat = 127
    
    lazy var welfareImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.clipsToBounds = true
        self.backgroundColor = UIColor.RGBHex(0xf3f3f3)
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        
        self.contentView.addSubview(welfareImageView)
        
        welfareImageView.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
            make.left.equalTo(13)
            make.right.equalTo(-13)
        }
        self.contentView.backgroundColor = UIColor.white
        self.welfareImageView.image = UIImage(named: "welfare_image")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
