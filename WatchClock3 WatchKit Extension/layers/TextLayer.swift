//
//  TextLayer.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/1.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import SpriteKit


enum TextContentStyle: Int, Codable {
    case TextContentDate
    case TextContentWeekDay
    case TextContentWeekTwo
    case TextContentLunar
    case TextContentLunar2
}
class TextLayer: WatchLayer {
    private enum CodingKeys: String, CodingKey {
        case fontName
        case fontSize
        case textContent
        case textColor
        case backImage
    }

    var fontName: String = ""
    var fontSize: CGFloat = 26
    var textContent: TextContentStyle = .TextContentDate
    var textColor: MyColor = MyColor.init(color: UIColor.white)
    var backImage: String = ""

    override func getTag() -> Int {
        return 6
    }

    override func getTitle() -> String {
        return "Text"
    }

    override func getLayerNode(layerNode: inout SKSpriteNode) {
        super.getLayerNode(layerNode: &layerNode)
        if let image = self.getImage() {
            let texture = SKTexture.init(image: image)
            layerNode.texture = texture
            var size = texture.size()
            size = CGSize.init(width: size.width * self.xScale, height: size.height * self.yScale)
            layerNode.size = size
        }

    }

    private var WeekStyle1: [String] = ["日", "一", "二", "三", "四", "五", "六"]
    private var WeekStyle2: [String] = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]

    var oldText: String = ""
    func getText() -> String {
        switch self.textContent {
        case .TextContentDate:
            return String(self.watch!.getDateValue(.day))
        case .TextContentWeekDay:
            let weekday = self.watch!.getDateValue(.weekday)
            return WeekStyle1[weekday - 1]
        case .TextContentWeekTwo:
            let weekday = self.watch!.getDateValue(.weekday)
            return WeekStyle2[weekday - 1]
        case .TextContentLunar:
            let lunarCalendar = Calendar.init(identifier: .chinese)
            let day = lunarCalendar.component(.day, from: self.watch!.curDate)
            return chineseDays[day - 1]
        case .TextContentLunar2:
            let lunarCalendar = Calendar.init(identifier: .chinese)
            let month = lunarCalendar.component(.month, from: self.watch!.curDate)
            let day = lunarCalendar.component(.day, from: self.watch!.curDate)
            return chineseMonths[month - 1] + chineseDays[day - 1]
        }
    }

    private var chineseMonths: [String] = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月",
                                           "九月", "十月", "冬月", "腊月"]
    private var chineseDays: [String] = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十","廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]


    override func getImage() -> UIImage? {

        var img: UIImage?

        var size: CGSize?

        if (self.backImage != "" && self.backImage != "empty") {
            img = UIImage.init(named: backImage)
        }

        self.oldText = self.getText()
        let text = NSString(string: oldText)

        var font: UIFont

        if (self.fontName == "") {
            font = UIFont.systemFont(ofSize: self.fontSize)
        } else {
            font = UIFont.init(name: self.fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        }

        let text_style = NSMutableParagraphStyle()
        text_style.alignment = NSTextAlignment.center

        let tmpTextColor = textColor.Color

        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: text_style, NSAttributedString.Key.foregroundColor: tmpTextColor]

        let rect = text.boundingRect(with: CGSize(width: 500, height: 500), options: [], attributes: attributes, context: nil)
        if (size == nil) {
            size = CGSize(width: rect.width, height: rect.height)

            if (size?.width == 0 || size?.height == 0) {
                size = CGSize(width: 10, height: 10)
            }

            if (img != nil) {
                size = CGSize.init(width: size!.width + 20, height: size!.height + 10)
            }
        }

        UIGraphicsBeginImageContext(size!)

        let context = UIGraphicsGetCurrentContext()

        if (img != nil) {
            img?.draw(in: CGRect(origin: CGPoint.zero, size: size!))
        } else {
            context?.setFillColor(UIColor.clear.cgColor)
            context?.fill(CGRect.init(x: 0, y: 0, width: size!.width, height: size!.height))
        }

        //vertically center (depending on font)
        let text_h = font.lineHeight
        let text_y = (size!.height - text_h) / 2
        let text_rect = CGRect(x: 0, y: text_y, width: size!.width, height: text_h)

        text.draw(in: text_rect.integral, withAttributes: attributes)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image

    }
    
    override func checkChanged() -> Bool {
        let text = self.getText()
        if (text != self.oldText) {
            return true
        }
        return false
    }

    override init() {
        super.init()
        self.y = -70
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fontName = try container.decode(String.self, forKey: .fontName)
        self.fontSize = try container.decode(CGFloat.self, forKey: .fontSize)
        self.textColor = try container.decode(MyColor.self, forKey: .textColor)
        self.textContent = try container.decode(TextContentStyle.self, forKey: .textContent)
        self.backImage = try container.decode(String.self, forKey: .backImage)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fontSize, forKey: .fontSize)
        try container.encode(fontName, forKey: .fontName)
        try container.encode(textColor, forKey: .textColor)
        try container.encode(textContent, forKey: .textContent)
        try container.encode(backImage, forKey: .backImage)
    }

}
