//
//  PackageCollectionViewCell.swift
//  IvyGate
//
//  Created by tjvs on 2019/6/12.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class PackageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PackageCollectionViewCell"
    static let itemSize = CGSize(width: 140, height: 160)
    
    lazy var bgImageView = UIImageView()
    lazy var bgView = UIView()
    lazy var nameLabel = UILabel()
    lazy var unitLabel = UILabel()
    lazy var oldProice = UILabel()
    lazy var priceLabel = UILabel()
    lazy var priceHourLabel = UILabel()
    
    fileprivate var didUpdateConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundView = bgView
        self.selectedBackgroundView = bgImageView
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(unitLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(oldProice)
        contentView.addSubview(priceHourLabel)
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.left.equalTo(10)
            make.right.equalTo(-12)
            make.bottom.equalTo(-20)
        }
        
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(18)
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(28)
            make.right.equalToSuperview().offset(-14)
        }
        
        oldProice.snp.makeConstraints { (make) in
            make.top.equalTo(priceLabel.snp.bottom).offset(2)
            
            make.height.equalTo(21)
            make.centerX.equalToSuperview()
        }
        
        unitLabel.snp.makeConstraints { (make) in
            make.right.equalTo(priceLabel.snp.left)
            make.left.equalTo(10)
            make.height.equalTo(16)
            make.bottom.equalTo(priceLabel).offset(-2)
        }
        
        priceHourLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(12)
            make.top.equalTo(oldProice.snp.bottom).offset(7)
        }
        
        bgView.layer.cornerRadius = 5
        bgView.layer.borderColor = UIColor.RGBHex(0xd8d8d8).cgColor
        bgView.layer.borderWidth = 0.5
        
        bgImageView.image = UIImage(named: "package_select")
        
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = UIColor.RGBHex(0x666666)
        
        priceLabel.textAlignment = .left
        priceLabel.font = UIFont.boldSystemFont(ofSize: 34)
        priceLabel.textColor = UIColor.RGBHex(0x00c97e)
        
        unitLabel.text = "¥"
        unitLabel.textAlignment = .right
        unitLabel.font = UIFont.boldSystemFont(ofSize: 17)
        unitLabel.textColor = UIColor.RGBHex(0x00c97e)
        
        
        
        
        priceHourLabel.textAlignment = .center
        priceHourLabel.font = UIFont.systemFont(ofSize: 10)
        priceHourLabel.textColor = UIColor.RGBHex(0xD8D8D8)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


