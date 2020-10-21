//
//  UIGradientView.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

class UIGradientView: UIView {
    
    lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    
    var gradientBackgroundColor:[CGColor] = [] {
        didSet{
            if gradientBackgroundColor.count > 0 {
                gradientLayer.colors = gradientBackgroundColor
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if gradientBackgroundColor.count > 0 {
            gradientLayer.frame = self.bounds
        }
    }
}
