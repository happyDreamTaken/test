//
//  UIProtocolButton.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

class UIProtocolButton: UIButton {
    
    lazy var protocolLabel = UILabel()
    
    func setTitle(_ font:CGFloat,_ text1:String,_ color1:Int,_ text2:String,_ color2:Int){
        let titleLeft = NSAttributedString(string: text1, attributes:
            [ NSAttributedString.Key.foregroundColor: UIColor.RGBHex(color1),
              NSAttributedString.Key.font: UIFont.systemFont(ofSize: font)
            ])
        let titleRight = NSAttributedString(string: text2, attributes:
            [ NSAttributedString.Key.foregroundColor: UIColor.RGBHex(color2),
              NSAttributedString.Key.font: UIFont.systemFont(ofSize: font)
            ])
        let maString = NSMutableAttributedString()
        maString.append(titleLeft)
        maString.append(titleRight)
        protocolLabel.attributedText = maString
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(protocolLabel)
        protocolLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        protocolLabel.textAlignment = .left
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
