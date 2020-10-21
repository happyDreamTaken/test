//
//  LoadView.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit
import SnapKit

class LoadView: UIView {

    lazy var logoImageView = UIImageView(frame: CGRect.zero)
    lazy var appNameLabel = UILabel(frame: CGRect.zero)
    lazy var appDesLabel = UILabel(frame: CGRect.zero)
    init() {
        super.init(frame: CGRect(origin: .zero, size: UIScreen.size))
        self.doInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.doInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doInit(){
        self.backgroundColor = UIColor.white
        
        setupSubViews()
        
        self.perform(#selector(removeFromSuperview), with: nil, afterDelay: 2)
    }
    
    func setupSubViews() {
        
        
        self.addSubview(logoImageView)
        self.addSubview(appNameLabel)
        self.addSubview(appDesLabel)
        
        logoImageView.image = UIImage(named: "app_logo")
        appNameLabel.text = "常春藤加速"
        appNameLabel.textColor = UIColor.black
        appNameLabel.font = UIFont.systemFont(ofSize: 17)
        appNameLabel.textAlignment = .center
        
        appDesLabel.text = "一键加速 全程护航"
        appDesLabel.textColor = UIColor.black
        appDesLabel.font = UIFont.systemFont(ofSize: 14)
        appDesLabel.textAlignment = .center
        
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-110)
            make.width.equalTo(85)
            make.height.equalTo(85)
        }
        
        appNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(27)
            make.height.equalTo(24)
            make.width.equalTo(200)
        }
        
        appDesLabel.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom).offset(-55)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
