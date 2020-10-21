//
//  UIColorExtension.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func RGBHex(_ rgb:Int)->UIColor {
        let r:CGFloat = CGFloat((rgb & 0xFF0000) >> 16)/255.0
        let g:CGFloat = CGFloat((rgb & 0xFF00) >> 8)/255.0
        let b:CGFloat = CGFloat((rgb & 0xFF))/255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    class func RGBAHex(_ rgba:Int64)->UIColor {
        let r:CGFloat = CGFloat((rgba & 0xFF0000) >> 24)/255.0
        let g:CGFloat = CGFloat((rgba & 0xFF0000) >> 16)/255.0
        let b:CGFloat = CGFloat((rgba & 0xFF00) >> 8)/255.0
        let a:CGFloat = CGFloat((rgba & 0xFF))/255.0
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    class func RGBInt(_ r:Int,g:Int,b:Int)->UIColor {
        let r:CGFloat = CGFloat(r)/255.0
        let g:CGFloat = CGFloat(g)/255.0
        let b:CGFloat = CGFloat(b)/255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    class func RGBAInt(_ r:Int,g:Int,b:Int,a:Int)->UIColor {
        let r:CGFloat = CGFloat(r)/255.0
        let g:CGFloat = CGFloat(g)/255.0
        let b:CGFloat = CGFloat(b)/255.0
        let a:CGFloat = CGFloat(a)/255.0
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
//    class func hexStringToColor(_ hexString: String, _ alpha: CGFloat) -> UIColor{
//        var cString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//        
//        if cString.characters.count < 6 {return UIColor.black}
//        if cString.hasPrefix("0X") {cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 2))}
//        if cString.hasPrefix("#") {cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))}
//        if cString.characters.count != 6 {return UIColor.black}
//        
//        var range: NSRange = NSMakeRange(0, 2)
//        
//        let rString = (cString as NSString).substring(with: range)
//        range.location = 2
//        let gString = (cString as NSString).substring(with: range)
//        range.location = 4
//        let bString = (cString as NSString).substring(with: range)
//        
//        var r: UInt32 = 0x0
//        var g: UInt32 = 0x0
//        var b: UInt32 = 0x0
//        Scanner.init(string: rString).scanHexInt32(&r)
//        Scanner.init(string: gString).scanHexInt32(&g)
//        Scanner.init(string: bString).scanHexInt32(&b)
//        
//        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(alpha))
//    }
    
    class func gradientColor(size:CGSize,colors:[CGColor]) -> UIColor?{
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = CGRect(origin: CGPoint.zero, size: size)
        gradientLayer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image)
    }
    
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hex: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if hex.hasPrefix("0X") {
            hex = hex.replacingOccurrences(of: "0X", with: "")
        }
        if hex.hasPrefix("0x") {
            hex = hex.replacingOccurrences(of: "0x", with: "")
        }
        if hex.hasPrefix("#") {
            hex = hex.replacingOccurrences(of: "#", with: "")
        }
        if hex.count == 6 {
            var r: UInt32 = 0x0
            var g: UInt32 = 0x0
            var b: UInt32 = 0x0
            let rString = (hex as NSString).substring(with: NSMakeRange(0,2))
            let gString = (hex as NSString).substring(with: NSMakeRange(2,2))
            let bString = (hex as NSString).substring(with: NSMakeRange(4,2))
            
            Scanner(string: rString).scanHexInt32(&r)
            Scanner(string: gString).scanHexInt32(&g)
            Scanner(string: bString).scanHexInt32(&b)
            self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(alpha))
        }else{
            self.init(white: 1, alpha: 0)
        }
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
    
    func getComponents() -> (CGFloat,CGFloat,CGFloat,CGFloat) {
        if (self.cgColor.numberOfComponents == 2) {
            let cc = self.cgColor.components;
            return (cc![0],cc![0],cc![0],cc![1])
        }
        else {
            let cc = self.cgColor.components;
            return (cc![0],cc![1],cc![2],cc![3])
        }
    }
    
    func interpolateRGBColorTo(_ end: UIColor, fraction: CGFloat) -> UIColor {
        var f = max(0, fraction)
        f = min(1, fraction)
        
        let c1 = self.getComponents()
        let c2 = end.getComponents()
        
        let r: CGFloat = CGFloat(c1.0 + (c2.0 - c1.0) * f)
        let g: CGFloat = CGFloat(c1.1 + (c2.1 - c1.1) * f)
        let b: CGFloat = CGFloat(c1.2 + (c2.2 - c1.2) * f)
        let a: CGFloat = CGFloat(c1.3 + (c2.3 - c1.3) * f)
        
        return UIColor.init(red: r, green: g, blue: b, alpha: a)
    }
}

