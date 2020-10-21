//
//  UIViewExtension.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

extension UIView {
    
    func getX() -> CGFloat {
        return self.frame.origin.x
    }
    
    func getY() -> CGFloat {
        return self.frame.origin.y
    }
    
    func getWidth() -> CGFloat {
        return self.frame.width
    }
    
    func getHeight() -> CGFloat {
        return self.frame.height
    }
    
    func moveTo(x:CGFloat,y:CGFloat) -> Void {
        self.frame = CGRect(origin: CGPoint(x: x, y: y),size: frame.size)
    }
    
    func move(x:CGFloat,y:CGFloat) -> Void {
        self.frame = self.frame.offsetBy(dx: x, dy: y)
    }    
}
