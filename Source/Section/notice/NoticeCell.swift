//
//  NoticeCell.swift
//  IvyGate
//
//  Created by MrFeng on 2019/10/24.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell {
    
    lazy var timeLabel = UILabel()
    lazy var nameLabel = UILabel()
    lazy var contentLabel = UILabel()
    lazy var rightImgView = UIImageView()
    lazy var lefttopImageView = UIImageView()
    lazy var bottomView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(bottomView)
        bottomView.addSubview(timeLabel)
        bottomView.addSubview(nameLabel)
        bottomView.addSubview(contentLabel)
        bottomView.addSubview(rightImgView)
        bottomView.addSubview(lefttopImageView)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        bottomView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(17)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-17)
            make.height.equalTo(106)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(self.frame.width/2 - 30)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(24)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(19)
            make.top.equalTo(timeLabel.snp.bottom).offset(5)
            make.height.equalTo(26)
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(19)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-67)
            make.height.equalTo(24)
        }
        
        rightImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalToSuperview().offset(-14)
            make.width.height.equalTo(18)
        }
        
        lefttopImageView.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel.snp.left).offset(-6)
            make.top.equalTo(nameLabel.snp.top)
            make.width.height.equalTo(12)
        }
        
        bottomView.backgroundColor = UIColor.RGBHex(0xF9FEFB)
        
        nameLabel.textColor = UIColor.RGBHex(0x000000)
        timeLabel.textColor = UIColor.RGBHex(0x4A4A4A)
        contentLabel.textColor = UIColor.RGBHex(0x4A4A4A)
        
        nameLabel.font = UIFont.systemFont(ofSize: 19)
        timeLabel.font = UIFont.systemFont(ofSize: 17)
        contentLabel.font = UIFont.systemFont(ofSize: 17)
        
        rightImgView.image = UIImage.init(named: "next")
        lefttopImageView.image = UIImage.init(named: "never_read")
    }
    
    
    func configure(notice:Notice) {
        self.timeLabel.text = notice.createTime
        self.contentLabel.text = notice.systemNoticeContent
        self.nameLabel.text = notice.systemNoticeTitle
        self.lefttopImageView.isHidden = (notice.systemNoticeReadStatus == 1)
        
    }
    
}
