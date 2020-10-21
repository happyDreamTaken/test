//
//  UIDescriptionView.swift
//  IvyGate
//
//  Created by MrFeng on 2019/10/22.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

/**
 *  @description ：首页中间模块App与网站皆可加速横向模块
 *  <#作为中间视图，在列表上拉用于固定在顶部的view#>
 *  top:UIProgressView.height
 *  <#change——y(UIProgressView.height ~ 0)#>
 *  
 */

class UIDescriptionView: UIView {

     lazy var greenView = UIView()
     lazy var listTitleLabel = UILabel()
     lazy var listNoteLabel = UILabel()
     lazy var joinButton = JoinButton()
     lazy var lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(greenView)
        self.addSubview(listTitleLabel)
        self.addSubview(listNoteLabel)
        self.addSubview(joinButton)
        self.addSubview(lineView)
        
        setupView()
        
        addConfigures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIDescriptionView {
    
    fileprivate func setupView() {
        joinButton.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.right.equalToSuperview().offset(40)
            make.width.equalTo(140)
            make.height.equalTo(50)
        }
        
        greenView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.width.equalTo(5)
            make.height.equalTo(32)
            make.top.equalTo(16)
        }
        
        listTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(34)
            make.right.equalTo(joinButton.snp.left).offset(-10)
            make.height.equalTo(25)
        }
        
        listNoteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(listTitleLabel.snp.bottom).offset(5)
            make.left.equalTo(listTitleLabel)
            make.right.equalTo(listTitleLabel)
            make.height.equalTo(14)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
            make.height.equalTo(0.5)
        }
        
        
    }
    
    
    fileprivate func addConfigures() {
        
        
         greenView.backgroundColor = UIColor.RGBHex(0x00c97e)
               
               listTitleLabel.text = "App与网站皆可加速"
               listTitleLabel.font = UIFont.systemFont(ofSize: 25)
               listTitleLabel.textColor = UIColor.RGBHex(0x233237)
               
               listNoteLabel.text = "与常春藤学校的同学们同步成长"
               listNoteLabel.font = UIFont.systemFont(ofSize: 14)
               listNoteLabel.textColor = UIColor.RGBHex(0x778087)
               
               joinButton.gradientBackgroundColor = [UIColor.RGBHex(0xFCC025).cgColor,UIColor.RGBHex(0xFC2525).cgColor]
               
               lineView.backgroundColor = UIColor.RGBAInt(0, g: 0, b: 0, a: 25)
    }
}
