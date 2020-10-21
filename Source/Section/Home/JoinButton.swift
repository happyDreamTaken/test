//
//  JoinButton.swift
//  IvyGate
//
//  Created by tjvs on 2019/6/1.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

class JoinButton: UIControl {

    lazy var titleLabel = UILabel(frame: .zero)
    lazy var buyLabel = UILabel(frame: .zero)
    lazy var goImageView = UIImageView(frame: .zero)
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    
    var gradientBackgroundColor:[CGColor] = [] {
        didSet{
            if gradientBackgroundColor.count > 0 {
                gradientLayer.colors = gradientBackgroundColor
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if gradientBackgroundColor.count > 0 {
            gradientLayer.frame = self.bounds
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.gradientLayer.cornerRadius = 25
        
        addSubview(titleLabel)
        addSubview(buyLabel)
        addSubview(goImageView)
        
        goImageView.snp.makeConstraints { (make) in
            make.width.equalTo(10)
            make.height.equalTo(16)
            make.right.equalTo(-45)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(goImageView.snp.left)
            make.top.equalTo(6)
            make.height.equalTo(18)
        }
        
        buyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(goImageView.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.height.equalTo(18)
        }
        
        titleLabel.text = ""
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = UIColor.white
        
        buyLabel.text = "会员充值"
        buyLabel.font = UIFont.systemFont(ofSize: 12)
        buyLabel.textColor = UIColor.white
        
        goImageView.image = UIImage(named: "open")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
