//
//  TickMarkLayer.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/1.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import SpriteKit

enum TickmarkStyle: Int, Codable {
    case TickmarkStyleAll, TickmarkStyleMajor, TickmarkStyleMinor, TickmarkStyleNone
}

enum NumeralStyle: Int, Codable {
    case NumeralStyleAll, NumeralStyleCardinal, NumeralStyleNone
}

class TickMarkLayer: WatchLayer {

    private enum CodingKeys: String, CodingKey {
        case tickmarkStyle
        case majorMarkColor
        case fontSize
        case fontName
        case textColor
        case labelMargin
        case numeralStyle
        case minorMarkColor
        case alternateMajorMarkColor
        case alternateMinorMarkColor
        case alternateTextColor
    }

    override func getTag() -> Int {
        return WatchLayer.TickMarkTag
    }

    override func getLayerNode(layerNode: inout SKSpriteNode) {
        super.getLayerNode(layerNode: &layerNode)

        let node = self.createTickMarkNode(self.name + "_marking")
//        node.maskNode = self.scene!.colorRegion!
        self.scene!.addChild(node)
        layerNode.size = CGSize.zero
        
        if self.scene!.watch!.Settings.showColorRegion {
            node.maskNode = self.scene!.colorRegion
            let alternateNode = self.createTickMarkNode(self.name+"_alternateMarking", useAlternateColor: true)
            self.scene?.addChild(alternateNode)
            alternateNode.maskNode = self.scene!.colorRegionReflection
        }
        
        
    }

    private var faceSize: CGSize = CGSize(width: 184, height: 224)

    var fontSize: CGFloat = 10
    var fontName: String = ""
    var textColor: MyColor = MyColor.init(color: UIColor.white)
    var labelMargin: CGFloat = 24
    var numeralStyle: NumeralStyle = .NumeralStyleAll
    var minorMarkColor: MyColor = MyColor.init(color: UIColor.white)
    var tickmarkStyle: TickmarkStyle = .TickmarkStyleAll
    var majorMarkColor: MyColor = MyColor.init(color: UIColor.white)

    var alternateMajorMarkColor: MyColor = MyColor.init(color: UIColor.white)
    var alternateMinorMarkColor: MyColor = MyColor.init(color: UIColor.white)
    var alternateTextColor: MyColor = MyColor.init(color: UIColor.white)

    func createTickMarkNode(_ layerName: String,useAlternateColor : Bool = false) -> SKCropNode {
        let margin: CGFloat = 1.0;

        let faceMarkings: SKCropNode = SKCropNode()

        faceMarkings.name = layerName;
        
        var tmpMajorMarkColor = self.majorMarkColor.Color
        var tmpMinorMarkColor = self.minorMarkColor.Color
        var tmpTextColor = self.textColor.Color
        
        if (useAlternateColor) {
            tmpMajorMarkColor = self.alternateMajorMarkColor.Color
            tmpMinorMarkColor = self.alternateMinorMarkColor.Color
            tmpTextColor = self.alternateTextColor.Color
        }

        /* Hardcoded for 44mm Apple Watch */

        for i in 0...12 {
            let angle: CGFloat = -(2 * CGFloat.pi) / 12.0 * CGFloat(i)
            let workingRadius: CGFloat = self.faceSize.width / 2
            let longTickHeight: CGFloat = workingRadius / 15

            let tick: SKSpriteNode = SKSpriteNode(color: tmpMajorMarkColor, size: CGSize(width: 2, height: longTickHeight))

            tick.position = CGPoint(x: 0, y: 0)
            tick.anchorPoint = CGPoint(x: 0.5, y: (workingRadius - margin) / longTickHeight)
            tick.zRotation = angle

            if (self.tickmarkStyle == .TickmarkStyleAll || self.tickmarkStyle == .TickmarkStyleMajor) {
                faceMarkings.addChild(tick)
            }

            var tmpStr: String = ""

            if (i == 0) {
                tmpStr = "12"
            } else {
                tmpStr = String(format: "%i", arguments: [i])
            }

            var numFont: UIFont = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium)

            if (fontName != "") {
                numFont = UIFont.init(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium)
            }

            let labelText: NSAttributedString = NSAttributedString(string: tmpStr, attributes: [NSAttributedString.Key.font: numFont, NSAttributedString.Key.foregroundColor: tmpTextColor])

            let numberLabel: SKLabelNode = SKLabelNode(attributedText: labelText)
            numberLabel.position = CGPoint(x: (workingRadius - labelMargin) * -sin(angle), y: (workingRadius - labelMargin) * cos(angle) - 9);

            if (numeralStyle == .NumeralStyleAll || ((numeralStyle == .NumeralStyleCardinal) && (i % 3 == 0))) {
                faceMarkings.addChild(numberLabel)
            }
        }

        for i in 0...60 {
            //        for (int i = 0; i < 60; i++)
            let angle: CGFloat = -(2 * CGFloat.pi) / 60.0 * CGFloat(i);
            let workingRadius: CGFloat = self.faceSize.width / 2;
            let shortTickHeight: CGFloat = workingRadius / 20;
            let tick: SKSpriteNode = SKSpriteNode(color: tmpMinorMarkColor, size: CGSize(width: 1, height: shortTickHeight))

            tick.position = CGPoint(x: 0, y: 0);
            tick.anchorPoint = CGPoint(x: 0.5, y: (workingRadius - margin) / shortTickHeight);
            tick.zRotation = angle;

            if (tickmarkStyle == .TickmarkStyleAll || tickmarkStyle == .TickmarkStyleMinor)
            {
                if (i % 5 != 0) {
                    faceMarkings.addChild(tick)
                }
            }
        }
        return faceMarkings
//        self.addChild(faceMarkings)

    }

    override func getTitle() -> String {
        return "TickMarkLayer"
    }


    override func getImage() -> UIImage? {
        #if os(iOS)
            if self.scene?.view != nil {
                let node = self.createTickMarkNode("temp")
                if let texture = self.scene?.view?.texture(from: node) {
                    let image = UIImage.init(cgImage: texture.cgImage())
                    return image
                }
            }
        #endif
        return nil
    }

    override init() {
        super.init()
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tickmarkStyle = try container.decode(TickmarkStyle.self, forKey: .tickmarkStyle)
        self.majorMarkColor = try container.decode(MyColor.self, forKey: .majorMarkColor)
        self.fontSize = try container.decode(CGFloat.self, forKey: .fontSize)
        self.fontName = try container.decode(String.self, forKey: .fontName)
        self.textColor = try container.decode(MyColor.self, forKey: .textColor)
        self.labelMargin = try container.decode(CGFloat.self, forKey: .labelMargin)
        self.numeralStyle = try container.decode(NumeralStyle.self, forKey: .numeralStyle)
        self.minorMarkColor = try container.decode(MyColor.self, forKey: .minorMarkColor)
        self.alternateMajorMarkColor = try container.decode(MyColor.self, forKey: .alternateMajorMarkColor)
        self.alternateMinorMarkColor = try container.decode(MyColor.self
                                                            , forKey: .alternateMinorMarkColor)
        self.alternateTextColor = try container.decode(MyColor.self, forKey: .alternateTextColor)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tickmarkStyle, forKey: .tickmarkStyle)
        try container.encode(majorMarkColor, forKey: .majorMarkColor)
        try container.encode(fontSize, forKey: .fontSize)
        try container.encode(fontName, forKey: .fontName)
        try container.encode(textColor, forKey: .textColor)
        try container.encode(labelMargin, forKey: .labelMargin)
        try container.encode(numeralStyle, forKey: .numeralStyle)
        try container.encode(minorMarkColor, forKey: .minorMarkColor)
        try container.encode(alternateMajorMarkColor, forKey: .alternateMajorMarkColor)
        try container.encode(alternateMinorMarkColor, forKey: .alternateMinorMarkColor)
        try container.encode(alternateTextColor, forKey: .alternateTextColor)

    }
}
