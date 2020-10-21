//
//  RuleButton.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class RuleButton: UIControl {

    lazy var bgView = UIImageView(frame: .zero)
    lazy var titleLabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bgView)
        self.addSubview(titleLabel)
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview().offset(32)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        self.backgroundColor = UIColor.clear
        
        bgView.backgroundColor = UIColor.RGBHex(0xFEA327)
        bgView.layer.cornerRadius = 16
        
        titleLabel.text = "规则说明"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = UIColor.white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
