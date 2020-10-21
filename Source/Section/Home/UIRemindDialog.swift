//
//  UIRemindDialog.swift
//  IvyGate
//
//  Created by tjvs on 2019/6/12.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class UIRemindDialog: UIDialogView {

    lazy var textView = UITextView(frame: .zero)
    lazy var okButton = UIGradientButton(frame: .zero)
    lazy var cancelButton = UIButton()
    
    lazy var blueColor = [UIColor.RGBHex(0x05F000).cgColor,UIColor.RGBHex(0x02B7C8).cgColor]
    lazy var redColor = [UIColor.RGBHex(0xFCB825).cgColor,UIColor.RGBHex(0xFC4625).cgColor]
    
    var okHandler:( ()->Void  )?
    
    override func setupSubviews() {
        
        self.backgroundColor = UIColor.RGBAHex(0x00000066)
        addSubview(containerView)
        
        containerView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(400)
            make.centerY.equalToSuperview()
        }
        
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 15
        
        containerView.addSubview(textView)
        containerView.addSubview(okButton)
        containerView.addSubview(cancelButton)
        
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-50)
            make.height.equalTo(50)
        }
        
        okButton.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(cancelButton.snp.top).offset(-20)
            make.height.equalTo(50)
        }
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(80)
            make.bottom.equalTo(okButton.snp.top).offset(-10)
        }
        
        textView.font = UIFont.systemFont(ofSize: 23)
        textView.textColor = UIColor.RGBHex(0x233237)
        textView.textAlignment = .center
        textView.isEditable = false
        
        okButton.setTitle("立即充值", for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        okButton.gradientLayer.cornerRadius = 25
        
        okButton.gradientBackgroundColor = redColor
        okButton.addTarget(self, action: #selector(okButtonDidClick), for: .touchUpInside)
        
        cancelButton.layer.cornerRadius = 25
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.RGBHex(0x979797).cgColor
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        cancelButton.setTitleColor(UIColor.RGBHex(0x233237), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonDidClick), for: .touchUpInside)
    }
    
    @objc func okButtonDidClick(){
        self.dismiss()
        if let handler = self.okHandler {
            handler()
        }
    }
    
    @objc func cancelButtonDidClick(){
        self.dismiss()
    }

}
