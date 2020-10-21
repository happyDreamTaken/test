//
//  UIDialogView.swift
//  IvyGate
//
//  Created by tjvs on 2019/6/3.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

class UIDialogView: UIView {
    
    private static var dialog:UIDialogView?
    
    lazy var containerView = UIView(frame: .zero)
    
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
        addSubview(containerView)
        
        containerView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(self.snp.top).offset(100)
            make.bottom.equalTo(self.snp.bottom).offset(-100)
        }
        
        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func present(){
        if let view = UIDialogView.dialog {
            view.removeFromSuperview()
        }
        UIDialogView.dialog = self
        
        if let view = NavigationController.shared.topViewController?.view {
            view.addSubview(self)
            self.snp.remakeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func dismiss() {
        self.removeFromSuperview()
        UIDialogView.dialog = nil
    }
}
