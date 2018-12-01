//
//  TextLayer.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/1.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import SpriteKit


enum TextContentStyle : Int,Codable {
    case TextContentDate
    case TextContentWeekDay
    case TextContentWeekTwo
    case TextContentWeekThree
}
class TextLayer : WatchLayer {
    private enum CodingKeys: String, CodingKey {
        case fontName
        case fontSize
        case textContent
        case textColor
        case backImage
    }
    
    var fontName : String = ""
    var fontSize : CGFloat = 26
    var textContent : TextContentStyle = .TextContentDate
    var textColor : MyColor = MyColor.init(color: UIColor.white)
    var backImage : String = ""
    
    override func getTag() -> Int {
        return 6
    }
    
    override func getTitle() -> String {
        return "Text"
    }
    
    override func getLayerNode(layerNode: inout SKSpriteNode) {
        super.getLayerNode(layerNode: &layerNode)
    }
    
    override func getImage() -> UIImage? {
        return nil
    }
    
    override init() {
        super.init()
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
