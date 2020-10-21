//
//  UIWaitView.swift
//  IvyGate
//
//  Created by tjvs on 2019/6/12.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class UIWaitView: UIView {

    private static var waitView:UIWaitView?
    
    lazy var textLabel = UILabel(frame: .zero)
    
    init() {
        super.init(frame: .zero)
        self.setupSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    func setupSubviews(){
        
        self.backgroundColor = UIColor.RGBAHex(0x00000066)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        
//        addSubview(textLabel)
//        
//        textLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(20)
//            make.right.equalTo(-20)
//            make.centerY.equalToSuperview()
//            make.height.equalTo(20)
//        }
//        
//        textLabel.backgroundColor = UIColor.clear
//        textLabel.textColor = UIColor.white
//        textLabel.font = UIFont.systemFont(ofSize: 20)
//        textLabel.textAlignment = .center
//        textLabel.text = "正在处理，请稍候！"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func present(){
        if let view = UIWaitView.waitView {
            view.removeFromSuperview()
        }
        UIWaitView.waitView = self
        
        if let view = NavigationController.shared.topViewController?.view {
            view.addSubview(self)
            self.snp.remakeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    @objc func dismiss() {
        self.removeFromSuperview()
        UIWaitView.waitView = nil
    }
    
}
