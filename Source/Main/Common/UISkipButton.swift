//
//  UISkipButton.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

class UISkipButton: UIControl,CAAnimationDelegate {
    
    lazy var title = UILabel()
    var overCallback:()->Void = { }
    var clickCallback:()->Void = { }
    
    lazy var shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.RGBAHex(0x00000099)
        self.addSubview(title)
        
        title.text = "跳过"
        title.textColor = UIColor.white
//        title.font = UIFont.system
        
        initShapeLayer()
        self.addTarget(self, action: #selector(clickEvent), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        title.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    func initShapeLayer() ->Void  {
        shapeLayer.fillColor = UIColor.clear.cgColor //设置填充色
        shapeLayer.lineWidth = 2  //设置路径线的宽度
        shapeLayer.strokeColor = UIColor.red.cgColor //路径颜色
        self.layer.addSublayer(shapeLayer)
    }
    
    func startAnimation() {
        shapeLayer.path = UIBezierPath(ovalIn: CGRect(x: -1, y: -1, width: frame.width+2, height: frame.height+2)).cgPath
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = 1
        shapeLayer.removeAllAnimations()
        let baseAnimation = CABasicAnimation(keyPath: "strokeEnd")
        baseAnimation.duration = 3   //持续时间
        baseAnimation.fromValue = NSNumber(floatLiteral: 0)//0.0  //开始值
        baseAnimation.toValue = NSNumber(floatLiteral: 1.0) //1.0    //结束值
        baseAnimation.repeatDuration = 0  //重复次数
        baseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        baseAnimation.delegate = self
        shapeLayer.add(baseAnimation, forKey: nil) //给ShapeLayer添加动画
    }
    
    func stopAnimation() {
        shapeLayer.removeAllAnimations()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            overCallback()
        }
    }
    
    @objc func clickEvent() -> Void {
        stopAnimation()
        clickCallback()
    }
}
