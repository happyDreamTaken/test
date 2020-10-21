//
//  MyRechargeViewController.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class MyRechargeViewController: UIViewController {

    lazy var navigateBar = NavigateBar(frame: .zero)
    lazy var headView = MyRechargeHeadView(frame: .zero)
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
            make.height.equalTo(MyRechargeHeadView.cellHeight)
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
        
        navigateBar.titleLabel.text = "充值记录"
        navigateBar.titleLabel.font = UIFont.systemFont(ofSize: 17)
        navigateBar.backButton.addTarget(self, action: #selector(backButtonDidClick), for: .touchUpInside)
        
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.RGBHex(0xFFFFFF)
        tableView.backgroundColor = UIColor.RGBHex(0xFFFFFF)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        
        tableView.register(MyRechargeCell.self, forCellReuseIdentifier: MyRechargeCell.identifier)
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
    
    func refresh(){
        RechargeManager.shared.update { (error) in
            self.tableView.mj_header.endRefreshing()
            if let message = error {
                UINoticeDialog.present(message)
            }else{
                self.tableView.reloadData()
            }
        }
    }
    
    func loadMore(){
        RechargeManager.shared.loadNextPage { (error) in
            self.tableView.mj_footer.endRefreshing()
            if let message = error {
                UINoticeDialog.present(message)
            }else{
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func backButtonDidClick(){
        self.navigationController?.popViewController(animated: false)
    }

}

extension MyRechargeViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RechargeManager.shared.rechargeLogArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MyRechargeCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyRechargeCell.identifier, for: indexPath)
        if let myRechargeCell = cell as? MyRechargeCell {
            let index = indexPath.row
            let array = RechargeManager.shared.rechargeLogArray
            if index < array.count {
                let item = array[index]
                var timeText = item.createTime
                if timeText.count > 10 {
                    timeText = timeText.subString(to: 10)
                }
                myRechargeCell.timeLabel.text = timeText
                myRechargeCell.moneyLabel.text = "\(item.rechargeAmount)"
                myRechargeCell.setStatus(status: item.rechargeStatus ) //item.rechargeStatus
            }
        }
        return cell
        
    }
    
}

extension MyRechargeViewController : UITableViewDelegate {
    
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
