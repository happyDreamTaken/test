//
//  UIUpgradeDialog.swift
//  IvyGate
//
//  Created by tjvs on 2019/10/10.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class UIUpgradeDialog: UIDialogView {
    
    static func present(_ text:String){
        let dialog = UINoticeDialog()
        dialog.textView.text = text
        dialog.present()
    }
    
    lazy var titleLabel = UILabel(frame: .zero)
    lazy var textView = UITextView(frame: .zero)
    lazy var cancelButton = UIGradientButton(frame: .zero)
    lazy var okButton = UIGradientButton(frame: .zero)
    
    lazy var blueColor = [UIColor.RGBHex(0x00c97e).cgColor,UIColor.RGBHex(0x00c97e).cgColor]
    
    override func setupSubviews() {
        
        self.backgroundColor = UIColor.RGBAHex(0x00000066)
        addSubview(containerView)
        
        containerView.snp.makeConstraints { (make) in
            make.width.equalTo(320)
            make.height.equalTo(260)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 5
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(textView)
        containerView.addSubview(cancelButton)
        containerView.addSubview(okButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(30)
            make.height.equalTo(20)
        }
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(titleLabel.snp.bottom).offset(26)
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
        titleLabel.text = "检测到版本更新"
        
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.RGBHex(0x233237)
        textView.textAlignment = .left
        textView.isEditable = false
        textView.text = "新版本上线啦，快去更新哟"
        
        cancelButton.setTitle("暂不更新", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        cancelButton.gradientLayer.cornerRadius = 5
        cancelButton.gradientBackgroundColor = blueColor
        cancelButton.addTarget(self, action: #selector(cancelButtonDidClick), for: .touchUpInside)
        
        okButton.setTitle("立即更新", for: .normal)
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
        let link = "https://itunes.apple.com/cn/app/id1466906198?mt=8"
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
