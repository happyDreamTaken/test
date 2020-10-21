//
//  ShareView.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class ShareView: UIView {

    lazy var backgroundView = UIImageView()
    lazy var shareButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        addSubview(backgroundView)
        addSubview(shareButton)
        
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        shareButton.snp.makeConstraints { (make) in
            make.width.equalTo(68)
            make.height.equalTo(68)
            make.centerY.equalToSuperview()
            if UIScreen.width < 400 {
                make.right.equalTo(-7)
            }else{
                make.right.equalTo(-37)
            }
        }
        
        backgroundView.image = UIImage(named: "share_background")
        
        shareButton.setImage(UIImage(named: "share_button"), for: .normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
