//
//  ShareDetailViewController.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class ShareDetailViewController: UIViewController {

    lazy var navigateBar = NavigateBar(frame: .zero)
    lazy var bgView = UIImageView(frame: .zero)
    lazy var ruleButton = RuleButton(frame: .zero)
    lazy var shareImageView = UIImageView(frame: .zero)
    lazy var tableView = UITableView(frame: .zero)
    lazy var shareButton = UIButton(frame: .zero)
    lazy var numIconArray = ["share_num_1","share_num_2","share_num_3","share_num_4"]
    lazy var ruleTextArray:[String] = []
    lazy var ruleDetaulLink = "http://www.baidu.com"
    
    lazy var sharePopView:SharePopView = {
        let popView = SharePopView(frame: .zero)
        self.view.addSubview(popView)
        popView.snp.makeConstraints({ (make) in
            make.right.left.bottom.equalToSuperview()
            make.top.equalTo(self.view.snp.bottom).offset(-190)
        })
        popView.isHidden = true
        return popView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(navigateBar)
        self.view.addSubview(bgView)
        
        bgView.addSubview(ruleButton)
        bgView.addSubview(shareImageView)
        bgView.addSubview(tableView)
        bgView.addSubview(shareButton)
        
        navigateBar.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *)
                          {
                              make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                          }else {
            make.top.equalTo(self.view.snp.top).offset(UIApplication.shared.statusBarFrame.height)
                          }
            make.height.equalTo(44)
            make.left.right.equalToSuperview()
        }
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(navigateBar.snp.bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalToSuperview()
        }
        
        ruleButton.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(32)
            make.right.equalToSuperview()
            make.top.equalTo(20)
        }
        
        shareImageView.snp.makeConstraints { (make) in
            make.top.equalTo(34)
            make.centerX.equalToSuperview()
            make.width.equalTo(215)
            make.height.equalTo(100)
        }
        
        shareButton.snp.makeConstraints { (make) in
            make.width.equalTo(359)
            make.height.equalTo(69)
            make.centerX.equalToSuperview()
        
            if #available(iOS 11.0, *)
                          {
                              make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                          }else {
                if UIDevice.isIphoneX {
                    make.bottom.equalTo(self.view).offset(-34)
                }else {
                    make.bottom.equalTo(self.view)
                }
                          }
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(shareImageView.snp.bottom).offset(137)
            make.bottom.equalTo(shareButton.snp.top)
            make.left.equalTo(18)
            make.right.equalTo(-18)
        }
        
        self.view.backgroundColor = UIColor.white
        
        navigateBar.titleLabel.text = "邀请有礼"
        navigateBar.titleLabel.font = UIFont.systemFont(ofSize: 17)
        navigateBar.backButton.addTarget(self, action: #selector(backButtonDidClick), for: .touchUpInside)
    
        bgView.image = UIImage(named: "share_bg")
        bgView.isUserInteractionEnabled = true
        
        ruleButton.addTarget(self, action: #selector(ruleButtonDidClick), for: .touchUpInside)
        
        shareImageView.image = UIImage(named: "share_text_notice")
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.RGBHex(0xFFFFFF)
        tableView.backgroundColor = UIColor.RGBHex(0xF6FFFE)
        tableView.layer.cornerRadius = 5
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        
        tableView.register(ShareHeadCell.self, forCellReuseIdentifier: ShareHeadCell.identifier)
        tableView.register(ShareTextCell.self, forCellReuseIdentifier: ShareTextCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        shareButton.setImage(UIImage(named: "share_button_submit"), for: .normal)
        shareButton.addTarget(self, action: #selector(doShareButtonDidClick), for: .touchUpInside)
        
        IvyGateServerAPI.shared.ruleList { (data, error) in
            
            if let json = data,json["code"].intValue == 1 {
                self.ruleTextArray.removeAll()
                let array = json["data"].arrayValue
                for item in array  {
                    let ruleText = item["invitationRuleContent"].stringValue
                    self.ruleTextArray.append(ruleText)
                }
                self.tableView.reloadData()
            }
            
            IvyGateServerAPI.shared.ruleDetailLink { (data, error) in
                if let json = data,json["code"].intValue == 1 {
                    self.ruleDetaulLink = json["data"].stringValue
                }
            }
        }
        
    }
    
    
    @objc func backButtonDidClick(){
        self.sharePopView.isHidden = true
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func ruleButtonDidClick(){
        let ruleVC = WebViewController()
        ruleVC.title = "规则说明"
        ruleVC.link = ruleDetaulLink //"http://47.103.79.7:8081/uploaded/inviteexplain.html"
        
        NavigationController.shared.pushViewController(ruleVC, animated: false)
    }
    
    @objc func doShareButtonDidClick(){
        sharePopView.isHidden = false
    }
    
}

extension ShareDetailViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numIconArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return ShareHeadCell.cellHeight
        }
        let index = indexPath.row - 1
        var text = ""
        if index < self.ruleTextArray.count {
            text = self.ruleTextArray[index]
        }
        return ShareTextCell.getHeight(text)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        let index = indexPath.row
        if index == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: ShareHeadCell.identifier, for: indexPath)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: ShareTextCell.identifier, for: indexPath)
            if let textCell = cell as? ShareTextCell, index-1 < self.ruleTextArray.count {
                textCell.headImageView.image = UIImage(named: self.numIconArray[index-1])
                textCell.textView.text = self.ruleTextArray[index-1]
            }
        }
        return cell
        
    }
    
}

extension ShareDetailViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
