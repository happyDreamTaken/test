//
//  ConfirmMobieViewController.swift
//  IvyGate
//
//  Created by MrFeng on 2019/10/24.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class ConfirmMobieViewController: UIViewController {

    lazy var navigateBar = NavigateBar(frame: .zero)
    
    lazy var oldPhoneTextField = UITextField.init()
    
    lazy var checkNumField = UITextField.init()
    
    lazy var loginButton = UIGradientButton(type: .custom)
    
    lazy var getCodeButton = UICountdownButton(frame: .zero)
    lazy var nextBtn = UIButton.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(navigateBar)
        
        self.view.backgroundColor = UIColor.white
        
        
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
        navigateBar.titleLabel.text = "更换新手机号"
        navigateBar.titleLabel.font = UIFont.systemFont(ofSize: 17)
        navigateBar.backButton.addTarget(self, action: #selector(backButtonDidClick), for: .touchUpInside)
        
        setup()
       
    }
    
    @objc func backButtonDidClick(){
        self.navigationController?.popViewController(animated: false)
    }
    
}

extension ConfirmMobieViewController {
    
    fileprivate func setup() {
        view.addSubview(oldPhoneTextField)
        view.addSubview(getCodeButton)
        view.addSubview(checkNumField)
        view.addSubview(loginButton)
         
        oldPhoneTextField.placeholder = "新手机号"
        checkNumField.placeholder = "验证码"
        getCodeButton.layer.cornerRadius = 5
        getCodeButton.setTitle("获取验证码", for: .normal)
        getCodeButton.backgroundColor = UIColor.RGBHex(0x00C97E)
        getCodeButton.addTarget(self, action: #selector(getCodeButtonDidClick), for: .touchUpInside)
            
        oldPhoneTextField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(36)
            make.top.equalTo(navigateBar.snp.bottom).offset(44)
            make.right.equalToSuperview().offset(-36)
            make.height.equalTo(26)
        }
        
        checkNumField.snp.makeConstraints { (make) in
            make.top.equalTo(oldPhoneTextField.snp.bottom).offset(39)
            make.left.equalToSuperview().offset(36)
            make.width.equalTo(200)
            make.height.equalTo(26)
            
        }
        
        getCodeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(checkNumField)
            make.width.equalTo(110)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-20)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(getCodeButton.snp.bottom).offset(109)
            make.left.equalToSuperview().offset(36)
            make.right.equalTo(-29.8)
            make.height.equalTo(50)
        }
        
        loginButton.setTitle("提交", for: .normal)
        let gradientColor = [UIColor.RGBHex(0x36E273).cgColor,UIColor.RGBHex(0x33CCB3).cgColor]
        loginButton.gradientBackgroundColor = gradientColor
        loginButton.gradientLayer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginButtonDidClick), for: .touchUpInside)
        
        self.addLine(topView: oldPhoneTextField)
        
        self.addLine(topView: checkNumField)
        
    }
    
    
    private func addLine(topView:UIView?) {
        let line = UIView.init()
        line.backgroundColor = UIColor.RGBHex(0xDBDBDB)
        view.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(23)
            make.top.equalTo(topView!.snp.bottom).offset(16)
            make.right.equalToSuperview().offset(-23)
            make.height.equalTo(1)
        }
    }
    
    // mark: 获取验证码
    @objc func getCodeButtonDidClick() {
        
        
        guard let mobile = oldPhoneTextField.text , mobile.count == 11 else {
                   CBToast.showToastAction(message: "请检验您的手机号")
                   return
               }
       
        checkNumField.becomeFirstResponder()
       
         self.getCodeButton.startTimer(60)
        IvyGateServerAPI.shared.smsCode(oldPhoneTextField.text!) { (res, error) in
            guard let json = res else {
                return
            }
            guard json["code"].intValue == 1 else {
                if let msg = json["msg"].string {
                    let dialog = UINoticeDialog(frame: .zero)
                    dialog.textView.text = msg
                    dialog.present()
                }
                return
            }
            
        }
        
    }
    
    // mark:成功之后返回
    // 需要判断验证码是否正确
    // 判断输入的手机号和验证码是否为空
    @objc func loginButtonDidClick() {
        guard let mobile = oldPhoneTextField.text , mobile.count == 11 else {
                   CBToast.showToastAction(message: "请检验您的手机号")
                   return
               }
               
               guard let codeNumber = checkNumField.text , codeNumber.count != 0 else {
                   CBToast.showToastAction(message: "请检验您的验证码是否正确")
                   return
               }
               
               //更新成新的手机号
               IvyGateServerAPI.shared.updateNewPhone(phone: mobile, verfyCode: codeNumber) { (res, error) in
                   guard let json = res else {
                       return
                   }
                
                guard json["code"].int == 1 else {
                    if let msg = json["msg"].string {
                        let dialog = UINoticeDialog(frame: .zero)
                        dialog.textView.text = msg
                        dialog.present()
                    }
                    return
                }
                   //用户信息刷新
                
                  let registVC =  RegisterViewController()
                registVC.comeFromNewMobiePage = true
                
                   NavigationController.shared.pushViewController(registVC, animated: false)
               }
               
    }
}
