//
//  LogoutCell.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class LogoutCell: UITableViewCell {

    static let reuseIdentifier = "LogoutCell"
    static let cellHeight:CGFloat = 120
    
    lazy var logoutButton = UIGradientButton(type: .custom)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.clipsToBounds = true
        
        self.contentView.addSubview(logoutButton)
        
        logoutButton.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.right.equalTo(-13)
            make.height.equalTo(46)
            make.centerY.equalToSuperview()
        }
        
        logoutButton.setTitle("退出登录", for: .normal)
        let gradientColor = [UIColor.RGBHex(0x36E273).cgColor,UIColor.RGBHex(0x33CCB3).cgColor]
        logoutButton.gradientBackgroundColor = gradientColor
        logoutButton.gradientLayer.cornerRadius = 5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
