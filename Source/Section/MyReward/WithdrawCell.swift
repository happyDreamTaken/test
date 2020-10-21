//
//  WithdrawCell.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class WithdrawCell: UICollectionViewCell {
    
    static let identifier = "WithdrawCell"
    static let itemSize = CGSize(width: 110, height: 60)
    
    lazy var normalBgView = UIView()
    lazy var selectBgView = UIView()
    lazy var priceLabel = UILabel()
    lazy var nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(priceLabel)
        contentView.addSubview(nameLabel)
        
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(15)
            make.top.equalTo(14)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(10)
        }
        
//        contentView.layer.cornerRadius = 5
//        contentView.layer.borderColor = UIColor.RGBHex(0xd8d8d8).cgColor
//        contentView.layer.borderWidth = 0.5
        self.backgroundView = normalBgView
        normalBgView.layer.cornerRadius = 5
        normalBgView.layer.borderColor = UIColor.RGBHex(0xd8d8d8).cgColor
        normalBgView.layer.borderWidth = 0.5
        
        self.selectedBackgroundView = selectBgView
        selectBgView.layer.cornerRadius = 5
        selectBgView.layer.borderColor = UIColor.RGBHex(0x00c9e7).cgColor
        selectBgView.layer.borderWidth = 0.5
        
        priceLabel.text = "10元"
        priceLabel.textAlignment = .center
        priceLabel.font = UIFont.systemFont(ofSize: 15)
        priceLabel.textColor = UIColor.RGBHex(0x333333)
        
        nameLabel.text = "充话费"
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 10)
        nameLabel.textColor = UIColor.RGBHex(0x00C97E)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
