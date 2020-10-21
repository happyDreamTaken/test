//
//  SharePopView.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class SharePopView: UIView {

    static let cellHeight:CGFloat = 45
    
    lazy var shareWechatButton = ShareButton()
    lazy var shareFriendButton = ShareButton()
    lazy var shareQQButton = ShareButton()
    lazy var shareQQSpaceButton = ShareButton()
    lazy var lineView = UIView()
    lazy var cancelButton = UIButton()
    
    lazy var sLink = "http://api.ivygate.vip/mobile/registerPage?parentId="
    lazy var sTitle = "我在用常春藤加速器，英语教育网站综合提速80%，极速畅享国际教育资源，快来试试吧～"
    lazy var sDes = "英语教育网站的专属加速器。一键完成加速，保障网络全程稳定快速。"
    lazy var sImage = UIImage(named: "register_logo")
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(shareWechatButton)
        self.addSubview(shareFriendButton)
        self.addSubview(shareQQButton)
//        self.addSubview(shareQQSpaceButton)
        self.addSubview(lineView)
        self.addSubview(cancelButton)
        
        shareWechatButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.333)
            make.height.equalTo(78)
            make.left.equalTo(0)
            make.top.equalTo(15)
        }
        
        shareFriendButton.snp.makeConstraints { (make) in
            make.width.height.top.equalTo(shareWechatButton)
            make.left.equalTo(shareWechatButton.snp.right)
        }
        
        shareQQButton.snp.makeConstraints { (make) in
            make.width.height.top.equalTo(shareWechatButton)
            make.left.equalTo(shareFriendButton.snp.right)
        }
        
//        shareQQSpaceButton.snp.makeConstraints { (make) in
//            make.width.height.top.equalTo(shareWechatButton)
//            make.left.equalTo(shareQQButton.snp.right)
//        }
        
        lineView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview()
            make.top.equalTo(140)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(141)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        self.backgroundColor = UIColor.RGBHex(0xffffff)
        
        shareWechatButton.imageView.image = UIImage(named: "share_icon_wechat")
        shareWechatButton.titleLabel.text = "微信好友"
        shareWechatButton.addTarget(self, action: #selector(shareWechatButtonDidClick), for: .touchUpInside)
        
        shareFriendButton.imageView.image = UIImage(named: "share_icon_friend")
        shareFriendButton.titleLabel.text = "朋友圈"
        shareFriendButton.addTarget(self, action: #selector(shareFriendButtonDidClick), for: .touchUpInside)
        
        shareQQButton.imageView.image = UIImage(named: "share_icon_qq")
        shareQQButton.titleLabel.text = "QQ好友"
        shareQQButton.addTarget(self, action: #selector(shareQQButtonDidClick), for: .touchUpInside)
        
//        shareQQSpaceButton.imageView.image = UIImage(named: "share_icon_qq_space")
//        shareQQSpaceButton.titleLabel.text = "QQ空间"
//        shareQQSpaceButton.addTarget(self, action: #selector(shareQQSpaceButtonDidClick), for: .touchUpInside)
        
        lineView.backgroundColor = UIColor.RGBHex(0xe5e5e5)
        
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.RGBHex(0x666666), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelButton.addTarget(self, action: #selector(cancelButtonDidClick), for: .touchUpInside)
    }
    
    @objc func cancelButtonDidClick(){
        self.isHidden = true
    }
    
    @objc func shareWechatButtonDidClick(){
        let sUrl = "\(self.sLink)\(User.shared.webUserId)"
        Wechat.shared.share(link: sUrl, title: sTitle, detail: sDes, thumbImage: sImage, to: .friend)
    }
    
    @objc func shareFriendButtonDidClick(){
        let sUrl = "\(self.sLink)\(User.shared.webUserId)"
        Wechat.shared.share(link: sUrl, title: sTitle, detail: sDes, thumbImage: sImage, to: .circle)
    }
    
    @objc func shareQQButtonDidClick(){
        let sUrl = "\(self.sLink)\(User.shared.webUserId)"
        Tencent.shared.share(link: sUrl, title: sTitle, detail: sDes, thumbImage: sImage, to: .qq)
    }
    
    @objc func shareQQSpaceButtonDidClick(){
        let sUrl = "\(self.sLink)\(User.shared.webUserId)"
        Tencent.shared.share(link: sUrl, title: sTitle, detail: sDes, thumbImage: sImage, to: .qzone)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
