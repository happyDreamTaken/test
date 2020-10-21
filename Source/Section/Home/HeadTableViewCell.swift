//
//  HeadTableViewCell.swift
//  IvyGate
//
//  Created by tjvs on 2019/9/2.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class HeadTableViewCell: UIView {

    static let reuseIdentifier = "HeadTableViewCell"
    static let cellHeight:CGFloat = 342
    
    lazy var progressView = UIProgressView()
    lazy var greenView = UIView()
    lazy var listTitleLabel = UILabel()
    lazy var listNoteLabel = UILabel()
    lazy var joinButton = JoinButton()
    lazy var lineView = UIView()
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        self.selectionStyle = .none
//        self.separatorInset = UIEdgeInsets.zero
//        self.layoutMargins = UIEdgeInsets.zero
//        self.preservesSuperviewLayoutMargins = false
//        self.clipsToBounds = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.addSubview(progressView)
        
        
        
        progressView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(0)
            make.width.equalTo(310)
            make.height.equalTo(138)
            make.centerX.equalToSuperview()
        }
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
