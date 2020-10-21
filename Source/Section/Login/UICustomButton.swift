//
//  UICustomButton.swift
//  IvyGate
//
//  Created by tjvs on 2019/8/26.
//  Copyright © 2019 yicheng. All rights reserved.
//

import UIKit

class UICustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    var normalBackgroundColor = UIColor.clear {
        didSet{
            if false == isTouchIn {
                self.backgroundColor = normalBackgroundColor
            }
        }
    }
    
    var focusedBackgroundColor = UIColor.gray {
        didSet{
            if isTouchIn {
                self.backgroundColor = focusedBackgroundColor
            }
        }
    }
    
    lazy var isTouchIn = false
    
    func didGetFocuse(){
        self.backgroundColor = focusedBackgroundColor
        self.isTouchIn = true
    }
    
    func didLostFocuse(){
        self.backgroundColor = normalBackgroundColor
        self.isTouchIn = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        didGetFocuse()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if self.isTouchIn {
            didLostFocuse()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if self.isTouchIn {
            didLostFocuse()
        }
    }
    
    
    
}
