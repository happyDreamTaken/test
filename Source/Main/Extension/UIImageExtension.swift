//
//  UIImageExtension.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

extension UIImage{
    
    var colorValue:UIColor {
        let color = UIColor(patternImage: self)
        return color
    }
    
    class func imageWithColor(_ color:UIColor,size:CGSize) -> UIImage{
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    /**
     *  压缩上传图片到指定字节
     *
     *  image     压缩的图片
     *  maxLength 压缩后最大字节大小
     *
     *  return 压缩后图片的二进制
     */
//    func compressImage(maxLength: Int) -> Data? {
//        
//        var compress:CGFloat = 0.9
//        var data = UIImageJPEGRepresentation(self, compress)
//        
//        while data != nil && data!.count > maxLength && compress > 0.01 {
//            compress -= 0.02
//            if compress < 0 { compress = 0.01 }
//            data = UIImageJPEGRepresentation(self, compress)
//        }
//        
//        return data
//    }
//    
//    static func compressImage(_ image: UIImage, toByte maxLength: Int) -> UIImage {
//        var compression: CGFloat = 1
//        guard var data = UIImageJPEGRepresentation(image, compression),
//            data.count > maxLength else { return image }
//        
//        // Compress by size
//        var max: CGFloat = 1
//        var min: CGFloat = 0
//        for _ in 0..<6 {
//            compression = (max + min) / 2
//            data = UIImageJPEGRepresentation(image, compression)!
//            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
//                min = compression
//            } else if data.count > maxLength {
//                max = compression
//            } else {
//                break
//            }
//        }
//        var resultImage: UIImage = UIImage(data: data)!
//        if data.count < maxLength { return resultImage }
//        
//        // Compress by size
//        var lastDataLength: Int = 0
//        while data.count > maxLength, data.count != lastDataLength {
//            lastDataLength = data.count
//            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
//            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
//                                      height: Int(resultImage.size.height * sqrt(ratio)))
//            UIGraphicsBeginImageContext(size)
//            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
//            data = UIImageJPEGRepresentation(resultImage, compression)!
//        }
//        return resultImage
//    }

    
    func scaleImage(image: UIImage, imageLength: CGFloat) -> CGSize {
        var newWidth: CGFloat = 0.0
        var newHeight: CGFloat = 0.0
        let width = image.size.width
        let height = image.size.height
        
        if (width > imageLength || height > imageLength) {
            if width > height {
                newWidth = imageLength
                newHeight = newWidth * height / width
            }else if height > width {
                newHeight = imageLength
                newWidth = newHeight * width / height
            }else {
                newWidth = imageLength
                newHeight = imageLength
            }
        }
        
        return CGSize(width: newWidth, height: newHeight)
    }
    
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0.0, y: 0.0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resizeableImage(image: UIImage) -> UIImage? {
        let imageWidth = image.size.width * 0.5
        let imageHeight = image.size.height * 0.5
        let normal = resizableImage(withCapInsets: UIEdgeInsets(top: imageHeight, left: imageWidth, bottom: imageHeight, right: imageWidth))
        
        return normal
    }
}
