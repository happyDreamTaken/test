//
//  UIConfirmDialog.swift
//  IvyGate
//
//  Created by tjvs on 2019/10/10.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class UIConfirmDialog: UIDialogView {
        
    static func present(_ text:String){
        let dialog = UINoticeDialog()
        dialog.textView.text = text
        dialog.present()
    }
    
    lazy var titleLabel = UILabel(frame: .zero)
    lazy var cancelButton = UIGradientButton(frame: .zero)
    lazy var okButton = UIGradientButton(frame: .zero)
    
    lazy var blueColor = [UIColor.RGBHex(0x00c97e).cgColor,UIColor.RGBHex(0x00c97e).cgColor]
    
    var okHandler:( ()->Void )?
    
    override func setupSubviews() {
        
        self.backgroundColor = UIColor.RGBAHex(0x00000066)
        addSubview(containerView)
        
        containerView.snp.makeConstraints { (make) in
            make.width.equalTo(320)
            make.height.equalTo(200)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 5
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(cancelButton)
        containerView.addSubview(okButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(38)
            make.bottom.equalTo(-70)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.width.equalTo(100)
            make.bottom.equalTo(-24)
            make.height.equalTo(46)
        }
        
        okButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.right.equalTo(-30)
            make.bottom.equalTo(-24)
            make.height.equalTo(46)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.RGBHex(0x233237)
        titleLabel.textAlignment = .center
        
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        cancelButton.gradientLayer.cornerRadius = 5
        cancelButton.gradientBackgroundColor = blueColor
        cancelButton.addTarget(self, action: #selector(cancelButtonDidClick), for: .touchUpInside)
        
        okButton.setTitle("确定", for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        okButton.gradientLayer.cornerRadius = 5
        okButton.gradientBackgroundColor = blueColor
        okButton.addTarget(self, action: #selector(okButtonDidClick), for: .touchUpInside)
        
    }
    
    @objc func cancelButtonDidClick(){
        self.dismiss()
    }
    
    @objc func okButtonDidClick(){
        self.dismiss()
        if let handler = self.okHandler {
            handler()
        }
    }

}
