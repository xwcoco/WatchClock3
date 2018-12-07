//
//  ClassExtensions.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/29.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class MyColor: Codable {
    private var colorHex: String = ""

    enum CodingKeys: String, CodingKey {
        case colorHex
    }

    private var cacheColor: UIColor?

    public var Color: UIColor {
        get {
            if (cacheColor != nil) {
                return self.cacheColor!
            }

            if (self.colorHex == "") {
                return UIColor.black
            }

            self.cacheColor = UIColor.init(hexString: self.colorHex)

            return cacheColor!
        }

        set {
            self.colorHex = newValue.toHex()
            self.cacheColor = newValue
        }

    }

    public convenience init(color: UIColor) {
        self.init()
        self.cacheColor = color
        self.colorHex = color.toHex()
    }

}



extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat

        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }

    public func toHex() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        guard r >= 0 && r <= 1 && g >= 0 && g <= 1 && b >= 0 && b <= 1 else {
            return ""
        }
        return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
    }

}

extension UIImage {
    public class func imageWithColor(color: UIColor, size: CGSize) -> UIImage? {

        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))

        context?.setFillColor(color.cgColor)
        context?.fill(CGRect.init(x: 1, y: 1, width: size.width - 2, height: size.height - 2))


        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    public class func imageWithPureColor(color: UIColor, size: CGSize) -> UIImage? {

        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(CGRect.init(x: 0, y: 0, width: size.width, height: size.height))

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    public func getImageWithSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)

        if (self.size.width > size.width || self.size.height > size.height) {
            self.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        } else {
            self.draw(at: CGPoint(x: (size.width - self.size.width) / 2, y: (size.height - self.size.height) / 2))
        }


        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self

    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func tint(color: UIColor, blendMode: CGBlendMode) -> UIImage
    {
        let drawRect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.clip(to: drawRect, mask: cgImage!)
//        CGContextClipToMask(context!, drawRect, CGImage)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
    
    //返回一个将白色背景变透明的UIImage
    func imageByRemoveWhiteBg() -> UIImage? {
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        return transparentColor(colorMasking: colorMasking)
    }
    
    //返回一个将黑色背景变透明的UIImage
    func imageByRemoveBlackBg() -> UIImage? {
        let colorMasking: [CGFloat] = [0, 32, 0, 32, 0, 32]
        return transparentColor(colorMasking: colorMasking)
    }
    
    func transparentColor(colorMasking:[CGFloat]) -> UIImage? {
        if let rawImageRef = self.cgImage {
            UIGraphicsBeginImageContext(self.size)
            if let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) {
                let context: CGContext = UIGraphicsGetCurrentContext()!
                context.translateBy(x: 0.0, y: self.size.height)
                context.scaleBy(x: 1.0, y: -1.0)
                context.draw(maskedImageRef, in: CGRect(x:0, y:0, width:self.size.width,
                                                        height:self.size.height))
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return result
            }
        }
        return nil
    }
    
    public func extraPixels(in size: CGSize) -> [UInt32]? {
        
        guard let cgImage = cgImage else {
            return nil
        }
        
        let width = Int(size.width)
        let height = Int(size.height)
        // 一个像素 4 个字节，则一行共 4 * width 个字节
        let bytesPerRow = 4 * width
        // 每个像素元素位数为 8 bit，即 rgba 每位各 1 个字节
        let bitsPerComponent = 8
        // 颜色空间为 RGB，这决定了输出颜色的编码是 RGB 还是其他（比如 YUV）
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // 设置位图颜色分布为 RGBA
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        var pixelsData = [UInt32](repeatElement(0, count: width * height))
        
        guard let content = CGContext(data: &pixelsData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        
        content.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        return pixelsData
    }
    
    public func pixelIndex(for point: CGPoint) -> Int? {
        let size = self.size
        guard point.x > 0 && point.x <= size.width
            && point.y > 0 && point.y <= size.height else {
                return nil
        }
        return (Int(point.y) * Int(size.width) + Int(point.x))
    }
    
    func getColorMasking() -> [CGFloat] {
        let pixels = self.extraPixels(in: self.size)
        let index = self.pixelIndex(for: CGPoint.init(x: 1, y: 1))
        let pixel = pixels![index!]
        let r = Int((pixel >> 0) & 0xff)
        let g = Int((pixel >> 8) & 0xff)
        let b = Int((pixel >> 16) & 0xff)
        return [CGFloat(r),CGFloat(r),CGFloat(g),CGFloat(g),CGFloat(b),CGFloat(b)]

    }
    
    func getTransImage() -> UIImage? {
        let colorMasking = self.getColorMasking()
        return transparentColor(colorMasking: colorMasking)
    }
    
    public func extraColor(for pixel: UInt32) -> UIColor {
        let r = Int((pixel >> 0) & 0xff)
        let g = Int((pixel >> 8) & 0xff)
        let b = Int((pixel >> 16) & 0xff)
        let a = Int((pixel >> 24) & 0xff)
        return UIColor.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
    }
    
}

extension NSObject
{
    // MARK:返回className
    var className:String{
        get{
            let name =  type(of: self).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1];
            }else{
                return name;
            }
            
        }
    }
    
}

