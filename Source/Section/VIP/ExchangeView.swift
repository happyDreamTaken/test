//
//  ExchangeView.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class ExchangeView: UIView {

    lazy var textField = UITextField(frame: .zero)
    lazy var exchangeButton = UIGradientButton(frame: .zero)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        addSubview(textField)
        addSubview(exchangeButton)
        
        exchangeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(46)
        }
        
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(exchangeButton)
            make.left.equalTo(0)
            make.right.equalTo(exchangeButton.snp.left).offset(-10)
            make.height.equalTo(exchangeButton)
        }
        
        textField.placeholder = "  请输入购买的时长码"
        textField.keyboardType = .asciiCapable
        textField.autocapitalizationType = .allCharacters
        textField.returnKeyType = .done
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.clearButtonMode = .whileEditing
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.RGBHex(0xc9c9c9).cgColor
        textField.layer.cornerRadius = 5
        
        let gradientColor = [UIColor.RGBHex(0xfcba25).cgColor,UIColor.RGBHex(0xfc5524).cgColor]
        exchangeButton.gradientBackgroundColor = gradientColor
        exchangeButton.gradientLayer.cornerRadius = 5
        exchangeButton.setTitle("立即兑换", for: .normal)
        exchangeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
