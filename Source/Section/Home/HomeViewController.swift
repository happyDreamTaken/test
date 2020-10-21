//
//  HomeViewController.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON



class HomeViewController: UIViewController {

    static let shared = HomeViewController()

//    lazy var headView = HeadTableViewCell(frame: .zero)
    
    lazy var progressView = UIProgressView()
    lazy var descriptionView = UIDescriptionView()
    
    lazy var titleLabel = UILabel()
    
    lazy var siteTableView:UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.isHidden = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    lazy var siteArray:[SiteModel] = []
    
    lazy var isReminded = false
    lazy var dataIsLoading = false
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func networkStatusChanged( _ usable:Bool ){
        guard self.navigationController?.topViewController == self else {
            return
        }
        guard true == usable else {
            return
        }
        if self.siteArray.count == 0 || User.shared.vipTime.count < 1 {
            self.loadSiteData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadSiteData()
        //刚注册的新用户
        if isReminded == false && User.shared.isNew {
            isReminded = true
            let dialog = UINoticeDialog(frame: .zero)
            dialog.textView.text = "恭喜，注册成功！\n您已获得\(User.shared.getLastDay())天的体验时长"
            dialog.present()
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        
        
       
    }
    
    func setupViews(){
        self.view.backgroundColor = UIColor.RGBHex(0xFFFFFF)
        
        
        self.view.addSubview(siteTableView)
        self.view.addSubview(progressView)
        self.view.addSubview(descriptionView)
        
        progressView.hideGif(didOpen: false)
        
        titleLabel.text = "常春藤加速"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.RGBHex(0x233237)
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
    
        
        progressView.switchButton.addTarget(self, action: #selector(switchButtonDidClick), for: .touchUpInside)
        descriptionView.joinButton.addTarget(self, action: #selector(joinButtonDidClick), for: .touchUpInside)
        
        if #available(iOS 11.0, *)
                         {
                             titleLabel.frame = CGRect.init(x: 0, y:view.safeAreaLayoutGuide.layoutFrame.minY, width: self.view.frame.width, height: 40)
                         }else {
                   titleLabel.frame = CGRect.init(x: 0, y:UIApplication.shared.statusBarFrame.height, width: self.view.frame.width, height: 40)
                         }
               
               siteTableView.frame = CGRect.init(x: 0, y: titleLabel.frame.maxY, width: self.view.frame.width, height: self.view.layoutMarginsGuide.layoutFrame.height)
               
               progressView.frame = CGRect.init(x: 0, y: titleLabel.frame.maxY, width: self.view.frame.width, height: 269)
               
               descriptionView.frame = CGRect.init(x: 0, y: progressView.frame.maxY, width: self.view.frame.width, height: 76)
        
        siteTableView.separatorStyle = .singleLine
        siteTableView.separatorColor = UIColor.RGBHex(0xFFFFFF)
        siteTableView.backgroundColor = UIColor.RGBHex(0xFFFFFF)
        if #available(iOS 11.0, *){
             siteTableView.contentInsetAdjustmentBehavior = .never
        }


        
        siteTableView.tableFooterView = UIView()
        
        siteTableView.delegate = self
        siteTableView.dataSource = self
        siteTableView.contentInset = UIEdgeInsets.init(top: 345, left: 0, bottom: 0, right: 0)
        siteTableView.register(SiteTableViewCell.self, forCellReuseIdentifier: SiteTableViewCell.reuseIdentifier)
        
    }
    
    func loadSiteData(){
        if  self.dataIsLoading {
            return
        }
        self.dataIsLoading = true
        IvyGateServerAPI.shared.siteList { (respose, error) in
            
            if let json = respose {
                
                guard json["code"].intValue == 1 else {
                    return
                }
                self.loadUserData()
                let data = json["data"].arrayValue
                self.siteArray.removeAll()
                var keywords:[String] = []
                for item in data {
                    let bean = SiteModel()
                    bean.webSiteId = item["webSiteId"].intValue
                    bean.webSiteName = item["webSiteName"].stringValue
                    bean.webSiteLogo = item["webSiteLogo"].stringValue
                    bean.webSiteLink = item["webSiteLink"].stringValue
                    bean.webSiteDetail = item["webSiteDetail"].stringValue
                    let keyString = item["webSiteKeyword"].stringValue
                    let keys = keyString.split(separator: ",")
                    for key in keys {
                        if key.count > 0 {
                            var useKey = String(key)
                            if useKey.first == "." {
                                useKey = useKey.subString(from: 1)
                            }
                            keywords.append(useKey)
                        }
                    }
                    bean.webSiteKeyword = keyString
                    self.siteArray.append(bean)
                }
                self.siteTableView.reloadData()
                self.progressView.switchButton.isEnabled = true
                VpnManager.shared.siteKeywords = keywords
            }else{
                Log.Info("error")
            }
        }
    }
    
    func loadUserData(){
        self.dataIsLoading = false
        guard User.shared.didLogin() else {
            return
        }
        User.shared.updateUserInfo {
            self.updateUserData()
        }
    }
    
    func updateUserData(){

        self.descriptionView.joinButton.titleLabel.text = "剩余\(User.shared.getLastDay())天"
        if isReminded == false && User.shared.isNew == false && User.shared.getLastDay() == 0 {
            self.isReminded = true
            let dialog = UIRemindDialog(frame: .zero)
            dialog.textView.text = "抱歉，您的体验时长已用完！\n请充值续费继续使用"
            dialog.okHandler = {
                self.joinButtonDidClick()
            }
            dialog.present()
        }
    }
    
    @objc func joinButtonDidClick(){
        self.tabBarController?.selectedIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onVPNStatusChanged_), name: NSNotification.Name(rawValue: "kProxyServiceVPNStatusNotification"), object: nil)
        
//        self.onVPNStatusChanged()
    }
    
    @objc func switchButtonDidClick() {
        
         progressView.switchButton.isSelected = !progressView.switchButton.isSelected
        if(VpnManager.shared.vpnStatus == .off){
            VpnManager.shared.connect()
        }else{
            VpnManager.shared.disconnect()
        }
       
    }
    
    @objc func onVPNStatusChanged_() {
        
        switch VpnManager.shared.vpnStatus {
        case .off:
            Log.Info("onVPNStatusChanged off")
            progressView.hideGif(didOpen: false)
            progressView.statusLabel.text = "加速器已关闭"
            progressView.switchButton.isSelected = false
        case .on:
            Log.Info("onVPNStatusChanged on")
            progressView.hideGif(didOpen: true)
            progressView.statusLabel.text = "加速器已开启"
            progressView.switchButton.isSelected = true
            
        case .connecting:
            Log.Info("onVPNStatusChanged connecting")
            progressView.hideGif(didOpen: true)
            progressView.statusLabel.text = "正在建立连接....."
            
        case .disconnecting:
            Log.Info("onVPNStatusChanged disconnecting")
            progressView.hideGif(didOpen: false)
            progressView.statusLabel.text = "正在断开连接....."
            
        }
        
    }
    
    @objc func onVPNStatusChanged(){
        switch VpnManager.shared.vpnStatus {
        case .off:
            Log.Info("onVPNStatusChanged off")
            progressView.hideGif(didOpen: false)
            progressView.statusLabel.text = "加速器已关闭"
            progressView.switchButton.isSelected = false
        case .on:
            Log.Info("onVPNStatusChanged on")
            progressView.hideGif(didOpen: true)
            progressView.statusLabel.text = "加速器已开启"
            progressView.switchButton.isSelected = true
            
        case .connecting:
            Log.Info("onVPNStatusChanged connecting")
            progressView.showGif()
            progressView.statusLabel.text = "正在建立连接....."
            
        case .disconnecting:
            Log.Info("onVPNStatusChanged disconnecting")
            progressView.hideGif(didOpen: false)
            progressView.statusLabel.text = "正在断开连接....."
            
        }
    }
}

extension HomeViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.siteArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SiteTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SiteTableViewCell.reuseIdentifier, for: indexPath)
        if let siteCell = cell as? SiteTableViewCell {
            let index = indexPath.row
            let bean = self.siteArray[index]
            
            if let url = URL(string: bean.webSiteLogo) {
                siteCell.siteButton.kf.setImage(with: url, for: .normal)
            }else{
                siteCell.siteButton.setImage(UIImage(named: "cell_icon"), for: .normal)
            }
            
            siteCell.titleLabel.text = bean.webSiteName
            siteCell.siteLabel.text = bean.webSiteLink
            siteCell.siteBtnClickHandler = { [weak self] cell in
                let cellTag = cell.tag
                self?.cellSiteButtonDidClick(cellTag)
            }
        }
        cell.tag = indexPath.row
        return cell
    }
    
    func cellSiteButtonDidClick( _ index:Int ){
        guard index < siteArray.count else {
            return
        }
        
//        if User.shared.getLastDay() == 0 {
//            let dialog = UIRemindDialog(frame: .zero)
//            dialog.textView.text = "您已没有足够的使用时长，为不影响正常使用，请及时充值续费。"
//            dialog.okHandler = {
//                self.joinButtonDidClick()
//            }
//            dialog.present()
//            return
//        }
        
        let site = self.siteArray[index]
        let detailViewController = SiteDetailViewController()
        detailViewController.siteTitle = site.webSiteName
        detailViewController.link = site.webSiteDetail
        NavigationController.shared.pushViewController(detailViewController, animated: true)
    }
}

extension HomeViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        self.cellSiteButtonDidClick(index)
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

extension HomeViewController {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= -345  {
            scrollView.contentOffset.y = -345
            titleLabel.frame = CGRect.init(x: titleLabel.frame.minX, y: view.layoutMarginsGuide.layoutFrame.minY, width: titleLabel.frame.width, height: titleLabel.frame.height)
            progressView.frame = CGRect.init(x: 0, y:titleLabel.frame.maxY, width: UIScreen.main.bounds.width, height: 269)
                   //
            descriptionView.frame = CGRect.init(x: 0, y:  progressView.frame.maxY, width: UIScreen.main.bounds.width, height: 76)
        }

        if offsetY > -345 && offsetY <= -76 {
             titleLabel.frame = CGRect.init(x: titleLabel.frame.minX, y:view.layoutMarginsGuide.layoutFrame.minY, width: titleLabel.frame.width, height: titleLabel.frame.height)
            progressView.frame = CGRect.init(x: 0, y: -(offsetY + 345) + titleLabel.frame.maxY, width: UIScreen.main.bounds.width, height: 269)

                descriptionView.frame = CGRect.init(x: 0, y: -(offsetY + 345) + 269 + titleLabel.frame.maxY, width: UIScreen.main.bounds.width, height: 76)
        }

        if offsetY > -76 && offsetY <= -view.layoutMarginsGuide.layoutFrame.minY {
            titleLabel.frame = CGRect.init(x: titleLabel.frame.minX, y: -(offsetY + view.layoutMarginsGuide.layoutFrame.minY), width: titleLabel.frame.width, height: titleLabel.frame.height)
            progressView.frame = CGRect.init(x: 0, y: -(offsetY + 345) + titleLabel.frame.maxY, width: UIScreen.main.bounds.width, height: 269)

            descriptionView.frame = CGRect.init(x: 0, y: progressView.frame.maxY , width: UIScreen.main.bounds.width, height: 76)
            if descriptionView.frame.minY < view.layoutMarginsGuide.layoutFrame.minY {
                descriptionView.frame = CGRect.init(x: 0, y: view.layoutMarginsGuide.layoutFrame.minY, width: self.view.frame.width, height: 76)
            }
        }

        if offsetY > -view.layoutMarginsGuide.layoutFrame.minY  {
            
            titleLabel.frame = CGRect.init(x: titleLabel.frame.minX, y: -(offsetY + view.layoutMarginsGuide.layoutFrame.minY), width: titleLabel.frame.width, height: titleLabel.frame.height)
            progressView.frame = CGRect.init(x: 0, y: -269 + view.layoutMarginsGuide.layoutFrame.minY, width: UIScreen.main.bounds.width, height: 269)

            descriptionView.frame = CGRect.init(x: 0, y: view.layoutMarginsGuide.layoutFrame.minY , width: UIScreen.main.bounds.width, height: 76)
        }

    }

}
