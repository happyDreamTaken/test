//
//  VIPViewController.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit
import SwiftyStoreKit

class VIPViewController: UIViewController {
    
    static let shared = VIPViewController()
    
    lazy var userInfoView = UserInfoView(frame: .zero)
    lazy var shareView = ShareView(frame: .zero)
    var isInExchangeAction = false
    lazy var exchangeView:ExchangeView = {
        let exchangeView = ExchangeView(frame: .zero)
        exchangeView.isHidden = true
        return exchangeView
    }()
    
    lazy var packageView = PackageView(frame: .zero)
    
    var packageArray:[PackageModel] = []
    
    lazy var tap:UITapGestureRecognizer = {
        let action = #selector(mineViewDidClick)
        let gr = UITapGestureRecognizer(target: self, action:action )
        self.view.addGestureRecognizer( gr )
        gr.isEnabled = false
        return gr
    }()
    
    override func viewDidLoad() {
        
        setupSubViews()
        
        exchangeView.textField.delegate = self
        exchangeView.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        exchangeView.exchangeButton.addTarget(self, action: #selector(exchangeButtonDidClick), for: .touchUpInside)
        
        packageView.protocolButton.addTarget(self, action: #selector(protocolButtonDidClick), for: .touchUpInside)
        packageView.collectionView.dataSource = self
        packageView.collectionView.delegate = self
    }
    
    deinit {
        IvyInPurchSafeManager.safeManager.debugWithInPurchaseInfo()
    }
    
    func setupSubViews(){
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(userInfoView)
        self.view.addSubview(shareView)
        self.view.addSubview(exchangeView)
        self.view.addSubview(packageView)
        
        userInfoView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview() //equalTo(self.view.safeAreaLayoutGuide.snp.top)
            if #available(iOS 11.0, *){
                make.top.equalToSuperview()
            }else {
                make.top.equalTo(self.view.snp.top).offset(UIApplication.shared.statusBarFrame.height)
            }
//            make.bottom.equalTo(self.view.snp.top).offset(189)
            if #available(iOS 11.0, *)
                          {
                            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(189)
                          }else {
                make.bottom.equalTo(self.view.snp.top).offset(UIApplication.shared.statusBarFrame.height + (self.navigationController?.navigationBar.frame.height ?? 0))
                          }
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        
        shareView.snp.makeConstraints { (make) in
            make.top.equalTo(userInfoView.snp.bottom).offset(16)
            make.left.equalTo(13)
            make.right.equalTo(-13)
            make.height.equalTo(75)
        }
        
        exchangeView.snp.makeConstraints { (make) in
            make.top.equalTo(shareView.snp.bottom).offset(24)
            make.height.equalTo(46)
            make.left.equalTo(13)
            make.right.equalTo(-13)
        }
        
        packageView.snp.makeConstraints { (make) in
            make.top.equalTo(exchangeView.snp.bottom).offset(26)
            make.height.equalTo(200)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        
        shareView.shareButton.addTarget(self, action: #selector(shareButtonDidClick), for: .touchUpInside)
    }
    
    @objc func shareButtonDidClick(){
        let shareVC = ShareDetailViewController()
        NavigationController.shared.pushViewController(shareVC, animated: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateUserInfo()
        
        IvyGateServerAPI.shared.packageList { (response, error) in
            self.getVipProtocol()
            guard let json = response else {
                return
            }
            guard let code = json["code"].int, code == 1 else {
                return
            }
            let data = json["data"].arrayValue
            self.packageArray.removeAll()
            for item in data {
                let bean = PackageModel()
                bean.vipPackageId = item["vipPackageId"].intValue
                bean.vipPackageName = item["vipPackageName"].stringValue
                bean.vipPackageTime = item["vipPackageTime"].intValue
                bean.vipPackagePrice = item["vipPackagePrice"].intValue
                bean.vipPackageStatus = item["vipPackageStatus"].intValue
                bean.vipPackageNumber = item["vipPackageNumber"].intValue
                bean.vipPackageUnit = item["vipPackageUnit"].intValue
                bean.vipPackageOldPrice = item["vipPackageOldPrice"].stringValue
                bean.vipPackageBuyId = item["vipPackageBuyId"].stringValue
                self.packageArray.append(bean)
            }
            
            self.packageView.collectionView.reloadData()
            self.packageView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top);
        }
        
//        SwiftyStoreKit.completeTransactions(atomically: true) { (purchases) in
//            for purchase in purchases {
//                if purchase.transaction.transactionState == .purchased
//                    || purchase.transaction.transactionState == .restored {
//
//                    if purchase.needsFinishTransaction {
//                        // Deliver content from server, then:
//                        SwiftyStoreKit.finishTransaction(purchase.transaction)
//                    }
//                }
//            }
//        }
        
    }
    
    @objc func backButtonDidClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateUserInfo(){
        self.userInfoView.nameLabel.text = "hi，\(User.shared.phone)"
        self.userInfoView.packageLabel.text = "\(User.shared.getLastDate())24时"
    }
}

// MARK: - <#Description#>
extension VIPViewController {
    
    func getVipProtocol() {
        guard User.shared.vipProtocolText.count < 1 else {
            return
        }
        IvyGateServerAPI.shared.vipProtocl { (response, error) in
            guard let json = response else{
                return
            }
            guard let code = json["code"].int , code == 1 else {
                return
            }
            User.shared.vipProtocolText = json["data"].stringValue
        }
    }
    
    @objc func protocolButtonDidClick(){
        self.exchangeView.textField.resignFirstResponder()
        guard let url = URL(string: User.shared.vipProtocolText) else {
            return
        }
        let dialog = UIProtocolDialog()
        dialog.titleLabel.text = "套餐及购买说明"
        dialog.textView.load(URLRequest.init(url: url))
        dialog.present()
    }
}

// MARK: - <#UITextFieldDelegate#>
extension VIPViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.tap.isEnabled = false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.tap.isEnabled = true
        return true
    }
    
    @objc func mineViewDidClick(){
        if self.exchangeView.textField.isFirstResponder {
            self.exchangeView.textField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.exchangeButtonDidClick()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if let text = textField.text, text.count == 8 {
            self.exchangeView.exchangeButton.alpha = 1.0
        }else{
            self.exchangeView.exchangeButton.alpha = 0.4
        }
    }
    
    @objc func exchangeButtonDidClick(){
        if isInExchangeAction {
            CBToast.showToastAction(message: "系统审核中,请稍后尝试")
        }
        isInExchangeAction = true
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            self.isInExchangeAction = true
        }
        self.exchangeView.textField.resignFirstResponder()
        guard let code = self.exchangeView.textField.text, code.count == 8 else {
            self.showErrorView("请输入正确的时长码")
            return
        }
        let phone = User.shared.phone
        
        IvyGateServerAPI.shared.exchangeCode(phoneNumber: phone, code: code) { (response, error) in
            guard let json = response else {
                return
            }
            guard let code = json["code"].int else {
                return
            }
            if code == 1  {
                if let vipTime = json["data"]["vipTime"].string {
                    User.shared.vipTime = vipTime
                }
                let vipCardTime = json["data"]["vipCardTime"].intValue
                UINoticeDialog.present("恭喜，时长码兑换成功！\n您已获得\(vipCardTime)天的体验时长")
                self.updateUserInfo()
                self.hideErrorView()
                self.exchangeView.textField.text = ""
            }else{
                self.showErrorView(json["msg"].stringValue)
            }
        }
    }
    
    func showErrorView( _ text:String ){
        UINoticeDialog.present(text)
//        self.vipView.noticeLabel.text = text
//        self.vipView.noticeLabel.isHidden = false
//        self.vipView.noticeImageView.isHidden = false
        
    }
    
    func hideErrorView(){
//        self.vipView.noticeLabel.isHidden = true
//        self.vipView.noticeImageView.isHidden = true
    }
}

// MARK: - <#UICollectionViewDataSource#>
extension VIPViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.packageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PackageCollectionViewCell.identifier, for: indexPath) as? PackageCollectionViewCell else {
            return PackageCollectionViewCell(frame: .zero)
        }
        let index = indexPath.item
        if index < self.packageArray.count {
            let bean = self.packageArray[index]
            cell.nameLabel.text = bean.vipPackageName
            cell.priceLabel.text = bean.priceText
            cell.priceHourLabel.text = bean.priceHourText
            let text = "¥".appending(bean.vipPackageOldPrice)
            cell.oldProice.attributedText = text.attribute(range: NSMakeRange(0, text.count), color: 0x9B9B9B)
        }
        
        
        return cell
    }
}

extension String {
    //富文本，添加删除线
       func attribute(range:NSRange ,color:Int = 0x9B9B9B) ->NSMutableAttributedString {
           let mutableString = NSMutableAttributedString.init(string: self)
           mutableString.addAttribute(.baselineOffset, value: 0, range: NSMakeRange(0, mutableString.length))
           mutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: NSMakeRange(0, mutableString.length))
           mutableString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, mutableString.length))
           mutableString.addAttribute(.foregroundColor, value: UIColor.RGBHex(color), range: NSMakeRange(0, mutableString.length))
           return mutableString
       }
       
}

extension VIPViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.exchangeView.textField.resignFirstResponder()
        
        let index = indexPath.item
        guard index < self.packageArray.count else {
            return
        }
        let bean = self.packageArray[index]
        self.submitOrder(package: bean)
    }
    
    func submitOrder( package:PackageModel ){
        let productID = package.vipPackageBuyId
        let packageID = package.vipPackageId
        let waitView = UIWaitView(frame: .zero)
        waitView.present()
        
        IvyGateServerAPI.shared.generateAnewOrder(vipPackageId: packageID) { (response, error) in
             guard let json = response else {
                           return
              }
            guard let code = json["code"].int else {
                           return
                       }
                       
            if code == 1 {
            
                if let orderNumber = json["data"]["orderNumber"].string {
                    UserDefaults.standard.set(orderNumber, forKey: "orderNumber")
                }
                UserDefaults.standard.set(packageID, forKey: "vipPackageId")
                
                //存储vipPackageBuyId和vipPackageId
                
                let orderNum:String = UserDefaults.standard.value(forKey: "orderNumber") as! String
                SwiftyStoreKit.purchaseProduct(productID, quantity: 1, atomically: true, applicationUsername: orderNum, simulatesAskToBuyInSandbox: false) { (result) in
                    waitView.dismiss()
                    
                                              switch result {
                                              case .success(let purchase):
                                                self.submitPackageOrder(packageID)
                                                  let pID = purchase.productId
                                                  let tState = purchase.transaction.transactionState
                                                  let tID = purchase.transaction.transactionIdentifier ?? ""
                                                  if let receiptData = SwiftyStoreKit.localReceiptData {
                                                      let receipt = receiptData.base64EncodedString(options: [])
                                                      //首先先保存当前信息
                                                      
                                                    self.queryOrder(pID: pID, state: "\(tState)", tID: tID, receipt: receipt) {
                                                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                                               
                                                    }
                                                  }else {
                                                      
                                                      self.queryOrder(pID: pID, state: "\(tState)", tID: tID, receipt: "") {
                                                          SwiftyStoreKit.finishTransaction(purchase.transaction)
                                                        
                                                      }
                                                  }
                                                 
                                                  
                                              case .error(let error):
                                                  switch error.code {
                                                  case .paymentCancelled:
                                                      Log.Info("用户取消支付")
                                                  default:
                                                      Log.Info(error)
                                                      UINoticeDialog.present(error.localizedDescription)  //"抱歉，充值续费失败！\n请重新尝试"
                                                  }
                                              }
                }
                
            }else {
                if let content = json["msg"].string {
                     UINoticeDialog.present(content)
                }
               
            }
        }
       
    }
    
    func submitPackageOrder(_ packageID:Int){
//        let phone = User.shared.phone
//        IvyGateServerAPI.shared.buyPackage(phoneNumber: phone, packageID: packageID) { (response, error) in
//            guard let json = response else {
//                return
//            }
//            guard let code = json["code"].int else {
//                return
//            }
//
//
//
//            if code == 1 {
//                if let vipTime = json["data"]["vipTime"].string {
//                    User.shared.vipTime = vipTime
//                }
//                let vipCardTime = json["data"]["vipCardTime"].intValue
//                UINoticeDialog.present("恭喜，套餐绑定成功！\n您已获得\(vipCardTime)天的体验时长")
//                self.updateUserInfo()
//            }else{
//                UINoticeDialog.present("抱歉，充值续费失败！\n请重新尝试")
//            }
//        }
        
        let packageId = UserDefaults.standard.value(forKey: "vipPackageId")
        let orderNumber = UserDefaults.standard.value(forKey: "orderNumber")
        
        
        
        IvyGateServerAPI.shared.buyPackage(vipPackageId: packageId as! Int, orderNumber: orderNumber as! String) { (response, error) in
            guard let json = response else {
                           return
            }
            guard let code = json["code"].int else {
                    return
            }
            
            UserDefaults.standard.removeObject(forKey: "packageId")
            UserDefaults.standard.removeObject(forKey: "orderNumber")
            
            if code == 1 {
                if let vipTime = json["data"]["vipTime"].string {
                    User.shared.vipTime = vipTime
                }
                let vipCardTime = json["data"]["vipCardTime"].intValue
                UINoticeDialog.present("恭喜，套餐绑定成功！\n您已获得\(vipCardTime)天的体验时长")
                self.updateUserInfo()
            }else {
                if code == -5 {
                     UINoticeDialog.present("抱歉，充值续费失败！\n请重新尝试")
                }
            }
            
        }
    }
    
    func queryOrder(pID:String,state:String,tID:String,receipt:String , completion:@escaping () -> Void){
        let phone = User.shared.phone
         IvyInPurchSafeManager.safeManager.isQueryOrder = true
        
        IvyGateServerAPI.shared.checkApplePay(phone:phone,
                                              pID: pID,
                                              state: state,
                                              tID: tID,
                                              receipt: receipt) { (respose, error) in
                                                
                                                
                                                if error == nil {
//                                                    IvyInPurchSafeManager.safeManager.clearProduct()
                                                }
                                                completion()
                                                
                                                
        }
        
    }
        
}
