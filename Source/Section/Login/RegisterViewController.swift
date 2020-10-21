//
//  RegisterViewController.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/24.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    lazy var titleLabel = UILabel(frame: .zero)
    lazy var logoImageView = UIImageView(frame: .zero)
    lazy var phoneIconView = UIImageView(frame: .zero)
    lazy var phoneTextField = UITextField(frame: .zero)
    lazy var getCodeButton = UICountdownButton(frame: .zero)
    lazy var phoneLine = UIView(frame: .zero)
    
    lazy var keyIconView = UIImageView(frame: .zero)
    lazy var keyTextField = UITextField(frame: .zero)
    lazy var keyLine = UIView(frame: .zero)
    lazy var loginButton = UIGradientButton(type: .custom)
    
    lazy var noticeLabel = UILabel(frame: .zero)
    
    var comeFromNewMobiePage:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews(){
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(logoImageView)
        self.view.addSubview(phoneIconView)
        self.view.addSubview(phoneTextField)
        self.view.addSubview(getCodeButton)
        self.view.addSubview(phoneLine)
        
        self.view.addSubview(keyIconView)
        self.view.addSubview(keyTextField)
        self.view.addSubview(keyLine)
        self.view.addSubview(loginButton)
        
        self.view.addSubview(noticeLabel)
        
        titleLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(view.snp.top).offset(12)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            }else {
                make.top.equalTo(view.snp.top).offset(UIApplication.shared.statusBarFrame.height + 12)
            }
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-28)
            make.height.equalTo(18)
        }
        
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(85)
           if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(106)
            }else {
                make.top.equalTo(view.snp.top).offset(UIApplication.shared.statusBarFrame.height + 106)
            }
        }
        
        phoneIconView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(256)
            make.left.equalToSuperview().offset(32)
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
        
        getCodeButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(244)
            make.right.equalToSuperview().offset(-28)
            make.width.equalTo(110)
            make.height.equalTo(40)
        }
        
        phoneTextField.snp.makeConstraints { (make) in
            make.top.equalTo(getCodeButton)
            make.height.equalTo(40)
            make.left.equalTo(phoneIconView.snp.right).offset(4)
            make.right.equalTo(getCodeButton.snp.left)
        }
        
        phoneLine.snp.makeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.bottom).offset(7)
            make.height.equalTo(0.5)
            make.left.equalTo(28)
            make.right.equalTo(-28)
        }
        
        keyIconView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(323)
            make.left.equalToSuperview().offset(32)
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
        
        keyTextField.snp.makeConstraints { (make) in
            make.centerY.equalTo(keyIconView)
            make.height.equalTo(40)
            make.left.equalTo(keyIconView.snp.right).offset(4)
            make.right.equalTo(-28)
        }
        
        keyLine.snp.makeConstraints { (make) in
            make.top.equalTo(keyTextField.snp.bottom).offset(7)
            make.height.equalTo(0.5)
            make.left.equalTo(28)
            make.right.equalTo(-28)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).offset(408)
            make.left.equalToSuperview().offset(28)
            make.right.equalTo(-28)
            make.height.equalTo(46)
        }
        
        noticeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-28)
            make.height.equalTo(13)
        }
        
        titleLabel.text = "常春藤加速"
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textColor = UIColor.RGBHex(0x333333)
        titleLabel.textAlignment = .center
        
        logoImageView.image = UIImage(named: "register_logo")
        
        phoneIconView.image = UIImage(named: "icon_phone")
        
        phoneTextField.placeholder = "请输入您的手机号"
//        phoneTextField.textColor = UIColor.RGBHex(0x999999)
        phoneTextField.font = UIFont.systemFont(ofSize: 17)
        phoneTextField.delegate = self
        phoneTextField.returnKeyType = .done
        phoneTextField.clearButtonMode = .whileEditing
        phoneTextField.keyboardType = .numberPad
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        getCodeButton.layer.cornerRadius = 5
        getCodeButton.setTitle("获取验证码", for: .normal)
        getCodeButton.backgroundColor = UIColor.RGBHex(0x00C97E)
        getCodeButton.addTarget(self, action: #selector(getCodeButtonDidClick), for: .touchUpInside)
        
        phoneLine.backgroundColor = UIColor.RGBAHex(0x00000020)
        
        keyIconView.image = UIImage(named: "icon_key")
        
        keyTextField.placeholder = "请输入验证码"
//        keyTextField.textColor = UIColor.RGBHex(0x999999)
        keyTextField.font = UIFont.systemFont(ofSize: 17)
        keyTextField.delegate = self
        keyTextField.returnKeyType = .done
        keyTextField.clearButtonMode = .whileEditing
        keyTextField.keyboardType = .numberPad
        keyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        keyLine.backgroundColor = UIColor.RGBAHex(0x00000020)
        
        loginButton.setTitle("立即登录", for: .normal)
        let gradientColor = [UIColor.RGBHex(0x36E273).cgColor,UIColor.RGBHex(0x33CCB3).cgColor]
        loginButton.gradientBackgroundColor = gradientColor
        loginButton.gradientLayer.cornerRadius = 5
        loginButton.addTarget(self, action: #selector(loginButtonDidClick), for: .touchUpInside)

        noticeLabel.text = "首次手机号登录将自动为您注册"
        noticeLabel.font = UIFont.systemFont(ofSize: 13)
        noticeLabel.textColor = UIColor.RGBHex(0x333333)
        noticeLabel.textAlignment = .center
        
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDidClick)))
    }
    
    @objc func getCodeButtonDidClick(){
        self.view.endEditing(true)
        let type = CaptchaType.puzzle

        CaptchaView.show(type) { (v) in
                   print("v--v\(v)")
            if v.count == 0 {
                return
            }
            guard let phoneNumber = self.phoneTextField.text, phoneNumber.count == 11 else {
                return
            }
        IvyGateServerAPI.shared.strongcheckSmsImages(captchaVerification: v, mobile: phoneNumber) {(response , error) in
                
                guard let json = response else {
                    self.noticeLabel.text = "验证失败"
                    return
                }
                
                let repData = json["data"]["success"].boolValue
                if repData == true {
                    self.getCodeButton.startTimer(60)
                     IvyGateServerAPI.shared.smsCode(phoneNumber) { (res, error) in
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
                         User.shared.phone = phoneNumber
                         self.noticeLabel.text = "验证码已发送"
                     }
                    
                    
                }else {
                    self.noticeLabel.text = "验证失败"
                }
                
            }
        
        }
        
        
    }
    
    @objc func loginButtonDidClick(){
        
        self.view.endEditing(true)
        
        let phoneNumber = phoneTextField.text ?? ""
        let text = keyTextField.text ?? ""
        IvyGateServerAPI.shared.login(phoneNumber, text) { (response, error) in
            if let json = response, let code = json["code"].int {
                switch code {
                case 1:
                    User.shared.updateData(json)
                    let deviceToken:String? = UserDefaults.standard.value(forKey: "deviceToken") as? String
                    
                    if let webUserId = json["data"]["webUserId"].int {
                        IvyGateServerAPI.shared.uploadPushInfomations(webUserId: webUserId, token: deviceToken ?? "未查找到", plateformType: 1) { (json, error) in
                            let code = json!["code"].int
                            if code == 1 {
                                #if DEBUG
                                  print("=====上传token成功=====")
                                #endif
                            }
                            NavigationController.shared.popToRootViewController(animated: false)
                        }
                    }
                    
                case 2:
                    User.shared.updateData(json)
                    User.shared.isNew = true
                   let deviceToken:String = UserDefaults.standard.value(forKey: "deviceToken") as! String
                    
                    if let webUserId = json["data"]["webUserId"].int {
                        IvyGateServerAPI.shared.uploadPushInfomations(webUserId: webUserId, token: deviceToken, plateformType: 1) { (json, error) in
                            let code = json!["code"].int
                            if code == 1 {
                                #if DEBUG
                                  print("=====上传token成功=====")
                                #endif
                            }
                            NavigationController.shared.popToRootViewController(animated: false)
                        }
                    }
                default:
                    self.noticeLabel.text = json["msg"].string ?? "验证码已失效，请重新发送"
                    self.noticeLabel.textColor = UIColor.RGBHex(0x008FFF)
                }
            }
        }
    }
    
    @objc func viewDidClick(){
        self.view.endEditing(true)
    }
}


extension RegisterViewController : UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField){
//        if textField == self.textField {
//            if var str = textField.text {
//                str = str.replacingOccurrences(of: "‭", with: "")
//                str = str.replacingOccurrences(of: " ", with: "")
//                str = str.trimmingCharacters(in: .whitespaces)
//                textField.text = str
//            }
//
//            self.changeNextStepButtonStatus()
//        }
        
    }
    
    func changeNextStepButtonStatus(){
//        if let text = self.textField.text, text.count == 11 {
//            self.nextStepButton.isEnabled = true
//            self.noticeLabel.text = "请点击下一步"
//            self.nextStepButton.isEnabled = true
//            self.nextStepButton.alpha = 1.0
//        }else{
//            self.nextStepButton.isEnabled = false
//            self.noticeLabel.text = "请输入手机号"
//            self.nextStepButton.isEnabled = false
//            self.nextStepButton.alpha = 0.4
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
