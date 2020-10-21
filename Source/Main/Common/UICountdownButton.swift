//
//  UICountDownButton.swift
//  IvyGate
//
//  Created by tjvs on 2019/6/2.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

class UICountdownButton: UIButton {

    lazy var counterLabel = UILabel()

    var counter:Int = 60
    var timer: Timer?
    var defaultTitle = "获取验证码"
    var retryTitle = "重新发送"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func startTimer(_ count:Int){
        counter = count
        timerBlock()
        if timer == nil {
            creatTimer()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        self.isEnabled = true
    }
    
    func creatTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (timer) in
            self?.timerBlock()
        }
    }
    
    func timerBlock(){
//        guard false == self.isEnabled else {
//            return
//        }
        if self.counter > 0 {
            let str = String(format: "%02i", self.counter)
            self.setTitle(("\(str)s"), for: .normal)
        }else {
            self.setTitle(self.retryTitle, for: .normal)
            self.isEnabled = true
        }
        self.counter = self.counter - 1
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
