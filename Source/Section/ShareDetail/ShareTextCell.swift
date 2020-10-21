//
//  ShareTextCell.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class ShareTextCell: UITableViewCell {

    static let identifier = "ShareTextCell"
    static let cellHeight:CGFloat = 72
    static func getHeight(_ text:String) ->CGFloat {
        let width = UIScreen.main.bounds.width - 100
        let words = width/18
        let lines:CGFloat = CGFloat(text.count)/words + 1.0
        return lines*15 + 20
    }
    
    lazy var headImageView = UIImageView()
//    lazy var textView = UITextView()
    lazy var textView = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.clipsToBounds = true
        
        self.contentView.addSubview(headImageView)
        self.contentView.addSubview(textView)
        
        headImageView.snp.makeConstraints { (make) in
//            make.top.equalTo(0)
            make.centerY.equalToSuperview()
            make.left.equalTo(25)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
        
        textView.snp.makeConstraints { (make) in
//            make.top.equalTo(headImageView)
            make.centerY.equalToSuperview()
            make.left.equalTo(headImageView.snp.right).offset(8)
            make.right.equalTo(-15)
            make.bottom.equalToSuperview()
        }
        
        self.contentView.backgroundColor = UIColor.clear
        
//        headImageView.backgroundColor = UIColor.red
//        textView.backgroundColor = UIColor.blue
        
        
//        textView.textContainerInset = UIEdgeInsets.zero
        textView.textAlignment = .left
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.textColor = UIColor.RGBHex(0x666666)
//        textView.isEditable = false
        textView.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
