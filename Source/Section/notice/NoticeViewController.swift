//
//  NoticeViewController.swift
//  IvyGate
//
//  Created by MrFeng on 2019/10/24.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class NoticeViewController: UIViewController {

    lazy var tableView = UITableView.init(frame: .zero, style: .plain)
    lazy var navigateBar = NavigateBar(frame: .zero)
    
    lazy var noticeArray = [Notice]()
    
    var page = 1
    var pageSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.view.addSubview(navigateBar)
        self.view.addSubview(tableView)
        
        
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
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(navigateBar.snp.bottom)
            make.bottom.equalToSuperview()
        }
        navigateBar.titleLabel.text = "公告"
        navigateBar.titleLabel.font = UIFont.systemFont(ofSize: 17)
        navigateBar.backButton.addTarget(self, action: #selector(backButtonDidClick), for: .touchUpInside)
        navigateBar.rightButton.setImage(UIImage.init(named: "clear_new"), for: .normal)
        navigateBar.rightButton.addTarget(self, action: #selector(tapOnRightBtn), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(NoticeCell.self, forCellReuseIdentifier: "notice")
        
        tableView.mj_header = MJRefreshHeaderView(refreshingBlock: {
            self.refresh()
        })
        tableView.mj_footer = MJRefreshFooterView(refreshingBlock: {
            self.loadMore()
        })
        
        tableView.mj_header.beginRefreshing()
        
//        self.getData()
    }
    
    func refresh(){
        self.page = 1
        self.getData()
    }
    
    func loadMore(){
        self.page += 1
        self.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    @objc func backButtonDidClick() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func tapOnRightBtn() {
        self.deleteAll()
    }
    
    func getData() {
        IvyGateServerAPI.shared.getNotice(page: self.page, limit: 10, webUserId: User.shared.webUserId) { (data, error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if let json = data, json["code"].int == 1
            {
                guard json["data"]["records"].count > 0 else {
                    CBToast.showToastAction(message: "无更多数据啦")
                    return
                }
                if self.page == 1 {
                    self.noticeArray.removeAll()
                }
                
                if json["data"]["total"].intValue < self.page {
                    self.page = json["data"]["total"].intValue
                    return
                }
                
                let items = json["data"]["records"].arrayValue
                for item in items {
                   let notice = Notice()
                    notice.systemNoticeTitle = item["systemNoticeTitle"].stringValue
                    notice.systemNoticeId = item["systemNoticeUserId"].intValue
                    notice.systemNoticeId = item["systemNoticeId"].intValue
                    
                    notice.systemNoticeContent = item["systemNoticeContent"].stringValue
                    notice.systemNoticeReadStatus = item["systemNoticeReadStatus"].intValue
                    notice.systemNoticeDeleteStatus = item["systemNoticeDeleteStatus"].intValue
                    notice.createTime = item["createTime"].stringValue
                    self.noticeArray.append(notice)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func deleteData(systemNoticeId:Int) {
        IvyGateServerAPI.shared.deleteNotice(systemNoticeUserId: systemNoticeId) { (data, error) in
            
        }
    }
    
    
    func deleteAll() {
        IvyGateServerAPI.shared.deleteAllNotices(webUserId: User.shared.webUserId) { (json, error) in
            let data = json!["code"].intValue
            if data == 1 {
                //删除成功
                self.noticeArray.removeAll()
                self.page = 1
                self.tableView.reloadData()
            }else {
                //删除失败
                if let message = error {
                    UINoticeDialog.present(message)
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
    
    
    func signDataAllReaded() {
        IvyGateServerAPI.shared.makeNoticesAllread(webUserId: User.shared.webUserId) { (json, error) in
            
        }
    }
    
    
    

}

extension NoticeViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : NoticeCell = tableView.dequeueReusableCell(withIdentifier: "notice", for: indexPath) as! NoticeCell
//        cell.backgroundColor = UIColor.RGBHex(0x979797)
        cell.selectionStyle = .none
        let notice = self.noticeArray[indexPath.row]
        cell.configure(notice:notice)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let item = self.noticeArray[indexPath.row]
        //未读
        if item.systemNoticeReadStatus == -1 {
          
            let deleteAction : UITableViewRowAction = UITableViewRowAction.init(style: .default, title: "删除") { (action, indexpath) in
                self.noticeArray.remove(at: indexPath.row)
                DispatchQueue.global().async {
                    
                    self.deleteData(systemNoticeId: item.systemNoticeId)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            }
            let readableAction : UITableViewRowAction = UITableViewRowAction.init(style: .normal, title: "已读") { (action, indexPath) in
                let notice = self.noticeArray[indexPath.row]
                self.signDataReaded(systemNoticeId:notice.systemNoticeId)
                  DispatchQueue.main.async {
                      self.tableView.reloadData()
                  }
            }
            
            return [deleteAction , readableAction]
        }else {
            
            let deleteAction : UITableViewRowAction = UITableViewRowAction.init(style: .default, title: "删除") { (action, indexpath) in
                            self.noticeArray.remove(at: indexPath.row)
                            self.tableView.reloadRows(at: [indexPath], with: .top)
                           DispatchQueue.global().async {
                               
                               self.deleteData(systemNoticeId: 123)
                               DispatchQueue.main.async {
                                  
                               }
                           }
                           
                       }
            return [deleteAction]
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //标记为已读
        //跳转到详情
        let item = self.noticeArray[indexPath.row]
        let noticeDetailVC = NoticeDescriptViewController()
        noticeDetailVC.notice = item
        noticeDetailVC.systemNoticeUserId = item.systemNoticeId
       
        noticeDetailVC.readBack = { (notice , sysId) in
            for item in self.noticeArray {
                if item.systemNoticeId == sysId {
                    item.systemNoticeReadStatus = 1
                }
            }
            self.tableView.reloadData()
            
        }
        NavigationController.shared.pushViewController(noticeDetailVC, animated: false)
        
    }
    
}

extension NoticeViewController {
    
}
