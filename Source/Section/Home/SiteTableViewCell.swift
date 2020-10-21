//
//  SiteTableViewCell.swift
//  IvyGate
//
//  Created by tjvs on 2019/6/2.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

class SiteTableViewCell: UITableViewCell {

    static let reuseIdentifier = "SiteTableViewCell"
    static let cellHeight:CGFloat = 95
    
    var siteBtnClickHandler:( ( _ cell:SiteTableViewCell )->Void )?
    lazy var containerView = UIImageView()
    lazy var siteButton = UIButton()
    lazy var titleLabel = UILabel()
    lazy var siteLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        self.preservesSuperviewLayoutMargins = false
        self.clipsToBounds = true
        
        self.addSubview(containerView)
        containerView.addSubview(siteButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(siteLabel)
        
        containerView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(-15)
            make.bottom.equalToSuperview().offset(0)
        }
        
        siteButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.top.equalTo(25)
            make.left.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.height.equalTo(21)
            make.left.equalTo(siteButton.snp.right).offset(10)
            make.right.equalTo(-15)
        }
        
        siteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.height.equalTo(16)
            make.right.equalTo(-15)
            make.left.equalTo(titleLabel)
        }
        
        let image = UIImage(named: "home_cell_bg")
        let stretchImage = image?.stretchableImage(withLeftCapWidth: 30, topCapHeight: 20)
        containerView.image = stretchImage //UIImage(named: "home_cell_bg")
        containerView.isUserInteractionEnabled = true
        
        siteButton.layer.cornerRadius = 25
        siteButton.addTarget(self, action: #selector(siteButtonDidClick), for: .touchUpInside)
        
        titleLabel.textColor = UIColor.RGBHex(0x171F24)
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .left
        
        siteLabel.textColor = UIColor.RGBHex(0xAAB2B7)
        siteLabel.font = UIFont.systemFont(ofSize: 12)
        siteLabel.textAlignment = .left
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func siteButtonDidClick(){
        if let handler = siteBtnClickHandler {
            handler(self)
        }
    }
    
}
