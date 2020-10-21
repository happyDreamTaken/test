//
//  NoticeDescriptViewController.swift
//  IvyGate
//
//  Created by MrFeng on 2019/10/29.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit
import WebKit

class NoticeDescriptViewController: UIViewController {

    lazy var navigateBar = NavigateBar(frame: .zero)
    
    lazy var titleMainLabel = UILabel()
    
    lazy var timeLabel = UILabel()
    
    lazy var webView = WKWebView()
    
    lazy var sepLine = UIView()
    
    var systemNoticeUserId :Int?
    
    var systemNoticeId : Int?
    
    var notice:Notice?
    
    typealias ReadBack = (_ notice:Notice? , _ systemNoticeUserId:Int?) -> Void
    var readBack:ReadBack?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.RGBHex(0xF9FEFB)
        
        self.view.addSubview(navigateBar)
        
        navigateBar.snp.makeConstraints { (make) in
                   if #available(iOS 11.0, *)
                                 {
                                     make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                                 }else {
                   make.top.equalTo(self.view.snp.top).offset(UIApplication.shared.statusBarFrame.height)
                                 }
                   make.height.equalTo(44)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
               }
        navigateBar.titleLabel.text = ""
        navigateBar.titleLabel.font = UIFont.systemFont(ofSize: 17)
        navigateBar.backButton.addTarget(self, action: #selector(backButtonDidClick), for: .touchUpInside)
        
        
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    @objc func backButtonDidClick() {
       
        if self.readBack != nil {
            self.readBack!(self.notice , self.systemNoticeUserId)
            
        }
            
        self.navigationController?.popViewController(animated: false)
    }
    
    
    
    
    func getData(systemNoticeUserId:Int = 0) {
        IvyGateServerAPI.shared.getNoticeDescription(systemNoticeUserId: self.systemNoticeUserId ?? 0) { (data, error) in
            
            if let json = data , json["code"] == 1 {
                
                self.signDataReaded(systemNoticeId: self.systemNoticeUserId!)
                
                let note = Notice()
                note.createTime = json["data"]["createTime"].stringValue
                note.systemNoticeTitle = json["data"]["systemNoticeTitle"].stringValue
                note.systemNoticeContent = json["data"]["systemNoticeContent"].stringValue
                note.systemNoticeReadStatus = json["data"]["systemNoticeReadStatus"].intValue
                note.systemNoticeDeleteStatus = json["data"]["systemNoticeDeleteStatus"].intValue
                note.systemNoticeSubtitle = json["data"]["systemNoticeSubtitle"].stringValue
                
                self.notice = note
                self.navigateBar.titleLabel.text = note.systemNoticeTitle
                self.timeLabel.text = note.createTime
                self.titleMainLabel.text = note.systemNoticeSubtitle
                self.webView.loadHTMLString(note.systemNoticeContent, baseURL: nil)
            }else {
                if let errorInfo = error {
                    UINoticeDialog.present(errorInfo)
                }
            }
        }
    }
    
    func signDataReaded(systemNoticeId:Int) {
        IvyGateServerAPI.shared.changeNoticeState(systemNoticeUserId: systemNoticeId) { (json, error) in
            if let data = json , data["code"] == 1{
                
            }
        }
    }

}


extension NoticeDescriptViewController {
    
    fileprivate func setupView() {
        self.view.addSubview(titleMainLabel)
        self.view.addSubview(timeLabel)
        self.view.addSubview(sepLine)
        self.view.addSubview(webView)
        
        titleMainLabel.snp.makeConstraints { (make) in
            make.top.equalTo(navigateBar.snp.bottom).offset(10)
            make.left.equalTo(self.view.snp.left).offset(33.8)
            
            make.right.equalTo(self.view.snp.right).offset(-33.8)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(33.8)
            make.top.equalTo(titleMainLabel.snp.bottom).offset(2)
            make.height.equalTo(21)
            
        }
        
        sepLine.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.top.equalTo(timeLabel.snp.bottom).offset(2)
            make.height.equalTo(1)
            make.right.equalTo(self.view.snp.right).offset(-28)
        }
        
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(sepLine.snp.bottom).offset(10)
            make.left.equalTo(self.view.snp.left).offset(21.5)
            make.right.equalTo(self.view.snp.right).offset(-14.5)
            make.bottom.equalTo(self.view.snp.bottom).offset(-50)
        }
        
        titleMainLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 33.8 * 2
        titleMainLabel.numberOfLines = 0
        titleMainLabel.textColor = UIColor.RGBHex(0x4A4A4A)
        titleMainLabel.font = UIFont.systemFont(ofSize: 19)
        
        timeLabel.textColor = .RGBHex(0x9B9B9B)
        timeLabel.font = UIFont.systemFont(ofSize: 15)
        
        sepLine.backgroundColor = .RGBHex(0xCCCCCC)
        
        webView.scrollView.isScrollEnabled = false
    }
    
}
