//
//  UINoticeDialog.swift
//  IvyGate
//
//  Created by tjvs on 2019/6/3.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

class UINoticeDialog: UIDialogView {
    
    static func present(_ text:String){
        let dialog = UINoticeDialog()
        dialog.textView.text = text
        dialog.present()
    }
    
    lazy var textView = UITextView(frame: .zero)
    lazy var okButton = UIGradientButton(frame: .zero)
    
    lazy var blueColor = [UIColor.RGBHex(0x05F000).cgColor,UIColor.RGBHex(0x02B7C8).cgColor]
    lazy var redColor = [UIColor.RGBHex(0xFCB825).cgColor,UIColor.RGBHex(0xFC4625).cgColor]
    
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
        
        containerView.addSubview(textView)
        containerView.addSubview(okButton)
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(38)
            make.bottom.equalTo(-70)
        }
        
        okButton.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.bottom.equalTo(-24)
            make.height.equalTo(46)
        }
        
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = UIColor.RGBHex(0x233237)
        textView.textAlignment = .center
        textView.isEditable = false
        
        okButton.setTitle("确认", for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        okButton.gradientLayer.cornerRadius = 5
        
        okButton.gradientBackgroundColor = blueColor
        
        
        okButton.addTarget(self, action: #selector(okButtonDidClick), for: .touchUpInside)
        
    }
    
    @objc func okButtonDidClick(){
        self.dismiss()
    }
}
