//
//  MyRewardViewController.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class MyRewardViewController: UIViewController {

    lazy var navigateBar = NavigateBar(frame: .zero)
    lazy var headView = MyInviteHeadView(frame: .zero)
    
    lazy var titleLabel = UILabel()
    lazy var collectionLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
    lazy var rechargeButton = UIGradientButton(type: .custom)
    lazy var noticeLabel = UILabel(frame: .zero)
    
    lazy var moneyArray = ["10元","30元","50元","100元","200元"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(navigateBar)
        self.view.addSubview(headView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(collectionView)
        self.view.addSubview(rechargeButton)
        self.view.addSubview(noticeLabel)
        
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
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(headView.snp.bottom).offset(27)
            make.height.equalTo(16)
            make.right.equalTo(-16)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(13)
            make.right.equalTo(-13)
            make.height.equalTo(178)
        }
        
        rechargeButton.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom)
            make.left.equalTo(13)
            make.right.equalTo(-13)
            make.height.equalTo(46)
        }
        
        noticeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(rechargeButton.snp.bottom)
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.height.equalTo(60)
        }
        
        self.view.backgroundColor = UIColor.white
        
        navigateBar.titleLabel.text = "我的奖励"
        navigateBar.titleLabel.font = UIFont.systemFont(ofSize: 17)
        navigateBar.backButton.addTarget(self, action: #selector(backButtonDidClick), for: .touchUpInside)
        navigateBar.rightButton.setTitle("充值记录", for: .normal)
        navigateBar.rightButton.addTarget(self, action: #selector(rightButtonDidClick), for: .touchUpInside)
        
        titleLabel.text = "提现额度"
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.RGBHex(0x333333)
        
        collectionLayout.itemSize = WithdrawCell.itemSize
        collectionLayout.minimumInteritemSpacing = 1
        collectionLayout.minimumLineSpacing = 10
        collectionLayout.scrollDirection = .vertical
        collectionLayout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(WithdrawCell.self, forCellWithReuseIdentifier: WithdrawCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        rechargeButton.setTitle("立即充值", for: .normal)
        let gradientColor = [UIColor.RGBHex(0x36E273).cgColor,UIColor.RGBHex(0x33CCB3).cgColor]
        rechargeButton.gradientBackgroundColor = gradientColor
        rechargeButton.gradientLayer.cornerRadius = 5
        rechargeButton.addTarget(self, action: #selector(rechargeButtonDidClick), for: .touchUpInside)
        
        noticeLabel.text = "1. 邀请好友成功购买获得奖励, 可以作为话费充值使用； \r\n2. 选择充值金额提交后，我们会尽快给您核实充值。"
        noticeLabel.numberOfLines = 3
        noticeLabel.font = UIFont.systemFont(ofSize: 13)
        noticeLabel.textColor = UIColor.RGBHex(0x666666)
        
        RewardManager.shared.updateWithdrawList { (error) in
            if let errorMsg = error {
                UINoticeDialog.present(errorMsg)
            }else{
                self.collectionView.reloadData()
                if RewardManager.shared.withdrawArray.count > 0 {
                    self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .top)
                }
            }
        }
        
        updateUserData()
    }
    
    func updateUserData(){
        headView.titleLabel.text = "奖励总金额"
        let leftText = "\(User.shared.invitationRewardBalance)"
        let rightText = "元"
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

    }
    
    @objc func backButtonDidClick(){
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func rightButtonDidClick(){
        NavigationController.shared.pushViewController(MyRechargeViewController(), animated: false)
    }
}

// MARK: - <#UICollectionViewDataSource#>
extension MyRewardViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RewardManager.shared.withdrawArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WithdrawCell.identifier, for: indexPath)
        if let withdrawCell = cell as? WithdrawCell {
            let index = indexPath.item
            let withdrawArray = RewardManager.shared.withdrawArray
            if index < withdrawArray.count {
                let money = "\(withdrawArray[index].rechargeAmount)元"
                withdrawCell.priceLabel.text = money
            }
        }
        return cell
    }
}

extension MyRewardViewController : UICollectionViewDelegate {
    
    @objc func rechargeButtonDidClick(){
        let index = self.collectionView.indexPathsForSelectedItems?.first?.item ?? 0
        let withdrawArray = RewardManager.shared.withdrawArray
        guard index < withdrawArray.count else { return }
        let withdrawBean = withdrawArray[index]
        let rechargeTagId = withdrawBean.rechargeTagId
        
        guard User.shared.invitationRewardBalance > Double(withdrawBean.rechargeAmount) else {
            UINoticeDialog.present("抱歉，您的账户剩余奖励金不足，请重新选择需要充值的金额")
            return
        }
        
        let dlg = UIConfirmDialog()
        dlg.titleLabel.text = "是否确认充值?"
        dlg.okHandler = {
            RewardManager.shared.doReward(rechargeTagId: rechargeTagId) { (error) in
                let message = error ?? "提现成功"
                UINoticeDialog.present(message)
                self.updateUserInfo()
            }
        }
        dlg.present()
    }
    
    func updateUserInfo(){
        User.shared.updateUserInfo {
            self.updateUserData()
        }
    }
    
}
