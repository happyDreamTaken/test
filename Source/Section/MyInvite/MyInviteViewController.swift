//
//  MyInviteViewController.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit
import MJRefresh

class MyInviteViewController: UIViewController {
    
    lazy var navigateBar = NavigateBar(frame: .zero)
    lazy var headView = MyInviteHeadView(frame: .zero)
    lazy var tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(navigateBar)
        self.view.addSubview(headView)
        self.view.addSubview(tableView)
        
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
        
        headView.snp.makeConstraints { (make) in
            make.top.equalTo(navigateBar.snp.bottom)
            make.height.equalTo(MyInviteHeadView.cellHeight)
            make.left.equalTo(13)
            make.right.equalTo(-13)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headView.snp.bottom)
            
            if #available(iOS 11.0, *)
                          {
                            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                          }else {
                make.bottom.equalTo(self.tabBarController?.tabBar.frame.minY ?? 0).offset(0)
                          }
            
            
            make.left.equalTo(13)
            make.right.equalTo(-13)
        }
        
        self.view.backgroundColor = UIColor.white
        
        navigateBar.titleLabel.text = "我的邀请"
        navigateBar.titleLabel.font = UIFont.systemFont(ofSize: 17)
        navigateBar.backButton.addTarget(self, action: #selector(backButtonDidClick), for: .touchUpInside)
        
        let leftText = "\(User.shared.invitationCount)"
        let rightText = "人"
        let titleLeft = NSAttributedString(string: leftText, attributes:
            [ NSAttributedString.Key.foregroundColor: UIColor.RGBHex(0xffffff),
              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 27)
            ])
        let titleRight = NSAttributedString(string: rightText, attributes:
            [ NSAttributedString.Key.foregroundColor: UIColor.RGBHex(0xffffff),
              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
              NSAttributedString.Key.baselineOffset:0
            ])
        let maString = NSMutableAttributedString()
        maString.append(titleLeft)
        maString.append(titleRight)
        headView.valueLabel.attributedText = maString
        
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.RGBHex(0xFFFFFF)
        tableView.backgroundColor = UIColor.RGBHex(0xFFFFFF)
        if #available(iOS 11.0, *) {
        tableView.contentInsetAdjustmentBehavior = .never
        }
        
        tableView.register(MyInviteCell.self, forCellReuseIdentifier: MyInviteCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.mj_header = MJRefreshHeaderView(refreshingBlock: {
            self.refresh()
        })
        tableView.mj_footer = MJRefreshFooterView(refreshingBlock: {
            self.loadMore()
        })
        
        tableView.mj_header.beginRefreshing()
    }
    
    @objc func backButtonDidClick(){
        self.navigationController?.popViewController(animated: false)
    }
    
    func refresh(){
        User.shared.updateUserInfo {
            InviteLogManger.shared.update { (error) in
                self.tableView.mj_header.endRefreshing()
                if let message = error {
                    UINoticeDialog.present(message)
                }else{
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func loadMore(){
        InviteLogManger.shared.loadNextPage { (error) in
            self.tableView.mj_footer.endRefreshing()
            if let message = error {
                UINoticeDialog.present(message)
            }else{
                self.tableView.reloadData()
            }
        }
    }

}

extension MyInviteViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InviteLogManger.shared.inviteLogArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MyInviteCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyInviteCell.reuseIdentifier, for: indexPath)
        if let inviteCell = cell as? MyInviteCell {
            let logs = InviteLogManger.shared.inviteLogArray
            let index = indexPath.row
            if index < logs.count {
                let item = logs[index]
                var timeText = item.createTime
                if timeText.count > 10 {
                    timeText = timeText.subString(to: 10)
                }
                inviteCell.timeLabel.text = timeText
                inviteCell.titleLabel.text = item.phone
            }
        }
        
        return cell

    }
    
}

extension MyInviteViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let index = indexPath.row
        //        if index < siteArray.count {
        //            let site = self.siteArray[index]
        //            guard let url = URL(string: site.webSiteLink) else {
        //                return
        //            }
        //            UIApplication.shared.open(url, options: [:]) { ( success ) in
        //                print("UIApplication open url \(success): \(site.webSiteLink)")
        //            }
        //        }
    }
}
