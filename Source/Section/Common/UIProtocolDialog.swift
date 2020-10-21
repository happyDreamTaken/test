//
//  UIProtocolDialog.swift
//  IvyGate
//
//  Created by tjvs on 2019/6/3.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit
import WebKit

class UIProtocolDialog: UIDialogView {

    lazy var backButton = UIButton(frame: .zero)
    lazy var titleLabel = UILabel(frame: .zero)
    lazy var textView = WKWebView()
    
    override func setupSubviews() {
        super.setupSubviews()
        containerView.backgroundColor = .white
        containerView.addSubview(backButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(textView)
        textView.backgroundColor = .white
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(5)
            make.top.equalTo(20)
            make.width.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(backButton)
            make.height.equalTo(backButton)
        }
        
        textView.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalTo(-20)
        }
        
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonDidClick), for: .touchUpInside)
        
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.RGBHex(0x02BDC3)
        titleLabel.textAlignment = .center
    }
    
    @objc func backButtonDidClick(){
        self.dismiss()
    }
}
