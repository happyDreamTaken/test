//
//  ItemUpImgView.swift
//  IvyGate
//
//  Created by MrFeng on 2019/10/23.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class ItemUpImgView: UIView {
    
    var atIndex:Int?
    
    lazy var bottomImgView:UIImageView = UIImageView()
    lazy var rightTopDeleteBtn:UIButton = UIButton()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bottomImgView)
        self.addSubview(rightTopDeleteBtn)
        
        rightTopDeleteBtn.clipsToBounds = false
        
        bottomImgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(11)
            make.top.equalToSuperview().offset(11)
            make.right.equalToSuperview().offset(-11)
            make.bottom.equalToSuperview().offset(-11)
        }
        
        rightTopDeleteBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(22)
            make.top.equalTo(0)
            make.right.equalTo(0)
        }
        rightTopDeleteBtn.setImage(UIImage.init(named: "image_delete"), for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
