//
//  NavigateBar.swift
//  IvyGate
//
//  Created by tjvs on 2019/6/2.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

class NavigateBar: UIView {
    
    lazy var backButton = UIButton()
    lazy var titleLabel = UILabel()
    lazy var rightButton:UIButton = {
        let btn = UIButton(frame: .zero)
        self.addSubview(btn)
        btn.snp.makeConstraints({ (make) in
            make.height.equalToSuperview()
            make.width.equalTo(68)
            make.right.equalTo(-15)
            make.top.equalToSuperview()
        })
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.RGBHex(0x666666), for: .normal)
        btn.titleLabel?.textAlignment = .right
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backButton)
        addSubview(titleLabel)
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(60)
            make.right.equalTo(-60)
        }
        
        backButton.setImage(UIImage(named: "back"), for: .normal)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.RGBHex(0x233237)
        titleLabel.textAlignment = .center
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
