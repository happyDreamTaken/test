//
//  ShareButton.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class ShareButton: UIControl {
    
    lazy var imageView = UIImageView(frame: .zero)
    lazy var titleLabel = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(42)
            make.height.equalTo(42)
            make.centerX.equalToSuperview()
            make.top.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(12)
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(13)
        }
        
        self.backgroundColor = UIColor.clear
        
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = UIColor.RGBHex(0x666666)
        titleLabel.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
