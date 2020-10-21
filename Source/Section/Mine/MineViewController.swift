//
//  MineViewController.swift
//  IvyGate
//
//  Created by tjvs on 2019/6/1.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class MineViewController: UIViewController {

    static let shared = MineViewController()
    
    lazy var tableView = UITableView(frame: CGRect.zero, style: .plain)
    lazy var menuText = ["去评论","我的邀请", "更换手机号","意见反馈"]
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
//            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            if #available(iOS 11.0, *)
                          {
                              make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                          }else {
                make.bottom.equalTo(self.view.snp.bottom).offset(self.tabBarController?.tabBar.frame.minY ?? 0)
                          }
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.RGBHex(0xFFFFFF)
        tableView.backgroundColor = UIColor.RGBHex(0xFFFFFF)
        if #available(iOS 11.0, *) {
           tableView.contentInsetAdjustmentBehavior = .never
        }
        
        
        tableView.register(MineCell.self, forCellReuseIdentifier: MineCell.reuseIdentifier)
        tableView.register(WelfareCell.self, forCellReuseIdentifier: WelfareCell.reuseIdentifier)
        tableView.register(MenuCell.self, forCellReuseIdentifier: MenuCell.reuseIdentifier)
        tableView.register(OfficalWeChatCell.self, forCellReuseIdentifier: OfficalWeChatCell.reuseIdentifier)
        tableView.register(VersionCell.self, forCellReuseIdentifier: VersionCell.reuseIdentifier)
        tableView.register(LogoutCell.self, forCellReuseIdentifier: LogoutCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
          self.AddLine()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let pID : String? = UserDefaults.standard.value(forKey: "productIdentifier") as? String
        if pID == nil || pID?.count == 0 {
            if menuText.count == 5 {
                menuText.removeLast()
            }
        }
        
        self.reloadAdData()
        self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
    @objc func backButtonDidClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func reloadAdData(){
        AdManager.shared.update {
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }
    }
}

extension MineViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 + menuText.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return MineCell.cellHeight
        case 1:
            return WelfareCell.cellHeight
            
        case 2 + menuText.count , 3 + menuText.count:
            return VersionCell.cellHeight
        case 4 + menuText.count:
            return LogoutCell.cellHeight
        default:
            return MenuCell.cellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: MineCell.reuseIdentifier, for: indexPath)
            if let mineCell = cell as? MineCell {
                mineCell.nameLabel.text = User.shared.phone
                mineCell.packgeLabel.text = "将于\(User.shared.getLastDate())到期"
                mineCell.setMoney(money: User.shared.invitationRewardBalance)
                mineCell.setInviteCount(count: User.shared.invitationCount)
                
                mineCell.rewardButton.addTarget(self, action: #selector(rewardButtonDidClick), for: .touchUpInside)
                mineCell.inviteButton.addTarget(self, action: #selector(inviteButtonDidClick), for: .touchUpInside)
                
                    mineCell.bingBtn.addTarget(self, action: #selector(messageBtnDidClick), for: .touchUpInside)
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: WelfareCell.reuseIdentifier, for: indexPath)
            if let wCell = cell as? WelfareCell {
                let imageLink = AdManager.shared.imageLink
                if imageLink.count > 0 {
                    wCell.welfareImageView.setImage(urlString: imageLink, placeholder: "welfare_image")
                }
            }
            
            
        case 2 + menuText.count:
            cell = tableView.dequeueReusableCell(withIdentifier: OfficalWeChatCell.reuseIdentifier, for: indexPath)
        case 3 + menuText.count:
            cell = tableView.dequeueReusableCell(withIdentifier: VersionCell.reuseIdentifier, for: indexPath)
           
        case 4 + menuText.count:
            cell = tableView.dequeueReusableCell(withIdentifier: LogoutCell.reuseIdentifier, for: indexPath)
            if let logoutCell = cell as? LogoutCell {
                logoutCell.logoutButton.addTarget(self, action: #selector(doMenuLogout), for: .touchUpInside)
            }
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: MenuCell.reuseIdentifier, for: indexPath)
            let index = indexPath.row - 2
            if index <= self.menuText.count , let menuCell = cell as? MenuCell {
                menuCell.titleLabel.text = self.menuText[index]
            }
        }
        return cell
    }
    
    @objc func rewardButtonDidClick(){
        NavigationController.shared.pushViewController(MyRewardViewController(), animated: false)
    }
    
    @objc func inviteButtonDidClick(){
        NavigationController.shared.pushViewController(MyInviteViewController(), animated: false)
    }
    
    @objc func messageBtnDidClick() {
        NavigationController.shared.pushViewController(NoticeViewController(), animated: false)
    }
    
}

extension MineViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        print("debug: tableView didSelectRowAt: \(index)")
        if menuText.count == 5 {
            if index == 7 {
                doMenuGetWecaht()
            }
        }
        switch index {
        case 1:
            doMenuGetWelfare()
        case 2:
            doMenuComment()
        case 3:
            doMenuMyInvite()
        case 4:
            doMenuChangeAccount()
        case 5:
            doMenuFeedback()
        case 6:
            if menuText.count == 5 {
                doMenuPushBugView()
            }else {
                doMenuGetWecaht()
            }
            
        default:
            print("debug: ignore menu index: \(index)")
        }
        
        
    }
    
    func doMenuGetWelfare() {
        if let url = URL(string: AdManager.shared.link) {
            let webVC = WebViewController()
            webVC.url = url
            NavigationController.shared.pushViewController(webVC, animated: false)
        }else{
            let shareDetailVC = ShareDetailViewController()
            NavigationController.shared.pushViewController(shareDetailVC, animated: false)
        }
    }
    
    func doMenuComment(){
        let link = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1466906198&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func doMenuMyInvite() {
        NavigationController.shared.pushViewController(MyInviteViewController(), animated: false)
    }
    
    func doMenuPushBugView() {
        if (UserDefaults.standard.value(forKey: "productIdentifier") == nil) {
            return
        }
        NavigationController.shared.pushViewController(BugViewController(), animated: false)
    }
    
    func doMenuFeedback() {
        NavigationController.shared.pushViewController(FeedbackViewController(), animated: false)
    }
    
    func doMenuGetWecaht() {
        NSSystemManager.manager.copyString(text: "845608363")
        CBToast.showToastAction(message: "复制成功")
//        let str = NSMutableString.init(string: "tel:15906217457")
//        UIApplication.shared.open(URL.init(string: str as String)!, options: [:]) { (isOk) in
//            
//        }
    }
    
    func doMenuChangeAccount() {
        NavigationController.shared.pushViewController(ChangeMyMobiePhone(), animated: false)
    }
    
    @objc func doMenuLogout(){
        let dlg = UIConfirmDialog()
        dlg.titleLabel.text = "确定退出登录？"
        dlg.okHandler = {
            let phone = User.shared.phone
            IvyGateServerAPI.shared.logout(mobile: phone) { (data, error) in
                if let json = data, json["code"].int == 1 {
                    User.shared.resetUserInfo()
                    NavigationController.shared.pushViewController(RegisterViewController(), animated: false)
                }
            }
        }
        dlg.present()
    }
    
}

extension MineViewController {
    
    //App生存期间只检测一次,
    
    func AddLine() {
        let pID : String? = UserDefaults.standard.value(forKey: "productIdentifier") as? String
        if pID?.count ?? 0 > 0 {
        menuText.append("支付Bug")
        tableView.reloadData()
         }
    }
    
}



