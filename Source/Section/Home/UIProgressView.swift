//
//  UIProgressView.swift
//  IvyGate
//
//  Created by tjvs on 2019/6/2.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class UIProgressView: UIView {

    lazy var statusLabel = UILabel()
    lazy var imageView = UIImageView(frame: .zero)
    lazy var gifView = UIImageView(frame: .zero)
    lazy var switchButton = UIButton()
    
    func hideGif( didOpen:Bool ){
        gifView.isHidden = true
        imageView.isHidden = false
        if didOpen {
            imageView.image = UIImage(named: "progress")
        }else{
            imageView.image = UIImage(named: "progress_")
        }
    }
    
    func showGif(){
        gifView.isHidden = false
        imageView.isHidden = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(statusLabel)
        addSubview(imageView)
        addSubview(gifView)
        addSubview(switchButton)
        self.backgroundColor = .white
        
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.height.equalTo(14)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(statusLabel.snp.bottom).offset(25)
            make.height.equalTo(98)
            make.width.equalTo(310)
            make.centerX.equalToSuperview()
        }
        
        gifView.snp.makeConstraints { (make) in
            make.edges.equalTo(imageView)
        }
        
        switchButton.snp.makeConstraints { (make) in
            make.top.equalTo(gifView.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
            make.width.equalTo(110)
            make.height.equalTo(64)
        }
        
        statusLabel.text = "网络流程，享受宝贵的学习时间"
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.textColor = UIColor.RGBHex(0x03C2B0)
        statusLabel.textAlignment = .center
        
        imageView.image = UIImage(named: "progress_")
        gifView.loadGif(name: "load_gif")
        
        switchButton.setImage(UIImage(named: "switch_off"), for: .normal)
        switchButton.setImage(UIImage(named: "switch_on"), for: .selected)
        switchButton.adjustsImageWhenHighlighted = false
        switchButton.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
