//
//  BugViewController.swift
//  IvyGate
//
//  Created by MrFeng on 2019/10/25.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class BugViewController: UIViewController {
    
    lazy var navigateBar = NavigateBar(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(navigateBar)
        self.view.backgroundColor = UIColor.white
               
               
               navigateBar.snp.makeConstraints { (make) in
                if #available(iOS 11.0, *)
                {
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                }else {
                    make.top.equalTo(self.view.snp.top).offset(0)
                }
                          make.height.equalTo(44)
                          make.left.right.equalToSuperview()
                      }
               navigateBar.titleLabel.text = "支付Bug"
               navigateBar.titleLabel.font = UIFont.systemFont(ofSize: 17)
               navigateBar.backButton.addTarget(self, action: #selector(backButtonDidClick), for: .touchUpInside)
        
        navigateBar.rightButton.setTitle("清除", for: .normal)
        navigateBar.rightButton.addTarget(self, action: #selector(tapOnRightBtn), for: .touchUpInside)
        
        setView()
    }
    
    @objc func backButtonDidClick() {
         self.navigationController?.popViewController(animated: false)
    }
    

    @objc func tapOnRightBtn() {
        IvyInPurchSafeManager.safeManager.clearProduct()
        self.navigationController?.popViewController(animated: false)
    }
    
    func setView() {
        
        let pId : String? = UserDefaults.standard.value(forKey: "productIdentifier") as? String
        if pId?.count == 0 {
            return
        }
        if pId!.count == 0 {
            self.navigationController?.popViewController(animated: false)
        }else {
            let filePath = NSHomeDirectory() + "/Documents/\(pId!).txt"
            
            let text = try! NSString.init(contentsOfFile: filePath, usedEncoding: nil)
            
            let label = UILabel.init(frame: self.view.bounds)
            label.textColor = UIColor.RGBHex(0x666666)
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.preferredMaxLayoutWidth = 280
            label.numberOfLines = 0
            label.text = text as String
            self.view.addSubview(label)
            
            label.snp.makeConstraints { (make) in
                make.center.equalTo(self.view)
                make.width.equalTo(280)
                make.height.equalTo(350)
            }
            
        }
    }

}
