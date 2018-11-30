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

