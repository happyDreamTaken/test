//
//  MineCell.swift
//  IvyGate
//
//  Created by tjvs on 2019/6/12.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class MineCell: UITableViewCell {
    
    static let reuseIdentifier = "MineCell"
    static let cellHeight:CGFloat = 190 + UIApplication.shared.statusBarFrame.height
    
    lazy var titleLabel = UILabel()
    lazy var headImageView = UIImageView()
    lazy var nameLabel = UILabel()
    lazy var packgeLabel = UILabel()
    lazy var greenBackground = UIView()
    lazy var rewardButton = UIButton()
    lazy var inviteButton = UIButton()
    lazy var lineView = UIView()
    lazy var bingBtn = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.clipsToBounds = true
        
        self.contentView.backgroundColor = UIColor.RGBHex(0xf8fbfe)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(headImageView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(packgeLabel)
        
        self.contentView.addSubview(greenBackground)
        self.contentView.addSubview(rewardButton)
        self.contentView.addSubview(inviteButton)
        self.contentView.addSubview(lineView)
        self.contentView.addSubview(bingBtn)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(14+UIApplication.shared.statusBarFrame.height)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(17)
        }
        headImageView.snp.makeConstraints { (make) in
            make.top.equalTo(67+UIApplication.shared.statusBarFrame.height)
            make.left.equalTo(23)
            make.width.equalTo(55)
            make.height.equalTo(55)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(78+UIApplication.shared.statusBarFrame.height)
            make.left.equalTo(93)
            make.right.equalTo(-23)
            make.height.equalTo(13)
        }
        packgeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(99+UIApplication.shared.statusBarFrame.height)
            make.left.equalTo(93)
            make.right.equalTo(-23)
            make.height.equalTo(13)
        }
        greenBackground.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(48)
        }
        rewardButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(greenBackground)
            make.left.equalTo(greenBackground)
            make.width.equalTo(greenBackground).multipliedBy(0.5)
            make.height.equalTo(greenBackground)
        }
        inviteButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(greenBackground)
            make.right.equalTo(greenBackground)
            make.width.equalTo(greenBackground).multipliedBy(0.5)
            make.height.equalTo(greenBackground)
        }
        lineView.snp.makeConstraints { (make) in
            make.centerY.equalTo(greenBackground)
            make.centerX.equalTo(greenBackground)
            make.width.equalTo(0.5)
            make.height.equalTo(24)
        }
        bingBtn.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.right.equalToSuperview().offset(-17.8)
            make.width.height.equalTo(29)
        }
        
        titleLabel.text = "我的"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor.RGBHex(0x333333)
        
        headImageView.image = UIImage(named: "head_image")
        
        nameLabel.text = "18051908900"
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        nameLabel.textColor = UIColor.RGBHex(0x333333)
        
        packgeLabel.text = "将于2019-07-30到期"
        packgeLabel.textAlignment = .left
        packgeLabel.font = UIFont.systemFont(ofSize: 13)
        packgeLabel.textColor = UIColor.RGBHex(0x333333)
        
        greenBackground.backgroundColor = UIColor.RGBHex(0xe5fbee)
        
        rewardButton.setAttributedTitle(15, "奖励金 ", 0x333333, "", 0xFA5800)
        inviteButton.setAttributedTitle(15, "邀请好友 ", 0x333333, "", 0xFA5800)
        
        lineView.backgroundColor = UIColor.RGBHex(0xd3d3d3)
        
        bingBtn.setImage(UIImage.init(named: "message"), for: .normal)

    }
    
    func setMoney(money:Double){
        rewardButton.setAttributedTitle(15, "奖励金 ", 0x333333, "\(money)元", 0xFA5800)
    }
    
    func setInviteCount(count:Int){
        inviteButton.setAttributedTitle(15, "邀请好友 ", 0x333333, "\(count)人", 0xFA5800)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UIButton {
    
    func setAttributedTitle(_ font:CGFloat,_ text1:String,_ color1:Int,_ text2:String,_ color2:Int){
        let titleLeft = NSAttributedString(string: text1, attributes:
            [ NSAttributedString.Key.foregroundColor: UIColor.RGBHex(color1),
              NSAttributedString.Key.font: UIFont.systemFont(ofSize: font)
            ])
        let titleRight = NSAttributedString(string: text2, attributes:
            [ NSAttributedString.Key.foregroundColor: UIColor.RGBHex(color2),
              NSAttributedString.Key.font: UIFont.systemFont(ofSize: font)
            ])
        let maString = NSMutableAttributedString()
        maString.append(titleLeft)
        maString.append(titleRight)
        self.setAttributedTitle(maString, for: .normal)
    }
}

