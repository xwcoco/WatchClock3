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

    override func setLayerNode(layerNode: inout SKSpriteNode) {
        super.setLayerNode(layerNode: &layerNode)

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

    var faceSize: CGSize = CGSize(width: 184, height: 224)

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

class RectTickMarkLayer : TickMarkLayer {
    override func getTag() -> Int {
        return WatchLayer.TickMarkTag
    }
    
    var labelXMargin : CGFloat = 18
    
    override func createTickMarkNode(_ layerName: String, useAlternateColor: Bool) -> SKCropNode {
        let margin: CGFloat = 1.0
        let labelYMargin: CGFloat = self.labelMargin
        let labelXMargin: CGFloat = self.labelXMargin
        
        let faceMarkings: SKCropNode = SKCropNode()
        faceMarkings.name = layerName
        
        var tmpMajorMarkColor = self.majorMarkColor.Color
        var tmpMinorMarkColor = self.minorMarkColor.Color
        var tmpTextColor = self.textColor.Color
        
        if (useAlternateColor) {
            tmpMajorMarkColor = self.alternateMajorMarkColor.Color
            tmpMinorMarkColor = self.alternateMinorMarkColor.Color
            tmpTextColor = self.alternateTextColor.Color
        }

        
        /* Major */
        for i in 0...12 {
            let angle: CGFloat = -(2 * CGFloat.pi) / 12.0 * CGFloat(i)
            let workingRadius: CGFloat = workingRadiusForFaceOfSizeWithAngle(self.faceSize, angle)
            let longTickHeight: CGFloat = workingRadius / 10.0
            
            let tick: SKSpriteNode = SKSpriteNode(color: tmpMajorMarkColor, size: CGSize(width: 2, height: longTickHeight))
            
            tick.position = CGPoint(x: 0, y: 0)
            tick.anchorPoint = CGPoint(x: 0.5, y: (workingRadius - margin) / longTickHeight)
            tick.zRotation = angle
            
            tick.zPosition = 0;
            
            if (tickmarkStyle == .TickmarkStyleAll || tickmarkStyle == .TickmarkStyleMajor) {
                faceMarkings.addChild(tick)
            }
        }
        
        /* Minor */
        for i in 0...60 {
            let angle: CGFloat = (2 * CGFloat.pi) / 60.0 * CGFloat(i)
            var workingRadius: CGFloat = workingRadiusForFaceOfSizeWithAngle(self.faceSize, angle)
            let shortTickHeight: CGFloat = workingRadius / 20
            let tick: SKSpriteNode = SKSpriteNode(color: tmpMinorMarkColor, size: CGSize(width: 1, height: shortTickHeight))
            
            /* Super hacky hack to inset the tickmarks at the four corners of a curved display instead of doing math */
            if (i == 6 || i == 7 || i == 23 || i == 24 || i == 36 || i == 37 || i == 53 || i == 54)
            {
                workingRadius -= 8
            }
            
            tick.position = CGPoint(x: 0, y: 0)
            tick.anchorPoint = CGPoint(x: 0.5, y: (workingRadius - margin) / shortTickHeight)
            tick.zRotation = angle
            
            tick.zPosition = 0
            
            if (tickmarkStyle == .TickmarkStyleAll || tickmarkStyle == .TickmarkStyleMinor)
            {
                if (i % 5 != 0)
                {
                    faceMarkings.addChild(tick)
                }
            }
        }
        
        /* Numerals */
        
        for i in 1...12
        {
            let fontSize: CGFloat = 25
            
            let labelNode: SKSpriteNode = SKSpriteNode(color: SKColor.clear, size: CGSize(width: fontSize, height: fontSize))
            labelNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            if (i == 1 || i == 11 || i == 12) {
                
                let tmpx: CGFloat = labelXMargin - self.faceSize.width / 2 + CGFloat(((i + 1) % 3)) * (self.faceSize.width - labelXMargin * 2) / 3.0 + (self.faceSize.width - labelXMargin * 2) / 6.0
                
                labelNode.position = CGPoint(x: tmpx, y: self.faceSize.height / 2 - labelYMargin)
            }
                
            else if (i == 5 || i == 6 || i == 7) {
                let tmpx: CGFloat = labelXMargin - self.faceSize.width / 2 + (2 - CGFloat(((i + 1) % 3))) * (self.faceSize.width - labelXMargin * 2) / 3.0 + (self.faceSize.width - labelXMargin * 2) / 6.0
                labelNode.position = CGPoint(x: tmpx, y: -self.faceSize.height / 2 + labelYMargin)
                
            }
            else if (i == 2 || i == 3 || i == 4) {
                let tmpy: CGFloat = -(self.faceSize.width - labelXMargin * 2) / 2 + (2 - CGFloat(((i + 1) % 3))) * (self.faceSize.width - labelXMargin * 2) / 3.0 + (self.faceSize.width - labelYMargin * 2) / 6.0
                labelNode.position = CGPoint(x: self.faceSize.height / 2 - fontSize - labelXMargin, y: tmpy)
                
            }
            else if (i == 8 || i == 9 || i == 10) {
                let tmpy: CGFloat = -(self.faceSize.width - labelXMargin * 2) / 2 + CGFloat(((i + 1) % 3)) * (self.faceSize.width - labelXMargin * 2) / 3.0 + (self.faceSize.width - labelYMargin * 2) / 6.0
                labelNode.position = CGPoint(x: -self.faceSize.height / 2 + fontSize + labelXMargin, y: tmpy)
            }
            
            faceMarkings.addChild(labelNode)
            
            let tmpStr: String = String(i)
            
            var numFont = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium)
            if (fontName != "") {
                numFont = UIFont.init(name: fontName, size: fontSize) ?? numFont
            }
            
            let labelText: NSAttributedString = NSAttributedString(string: tmpStr, attributes: [NSAttributedString.Key.font: numFont, NSAttributedString.Key.foregroundColor: tmpTextColor])
            
            let numberLabel: SKLabelNode = SKLabelNode(attributedText: labelText)
            
            numberLabel.position = CGPoint(x: 0, y: -9)
            
            if (numeralStyle == .NumeralStyleAll || ((numeralStyle == .NumeralStyleCardinal) && (i % 3 == 0))) {
                labelNode.addChild(numberLabel)
            }
        }
        return faceMarkings
    }
    
    func workingRadiusForFaceOfSizeWithAngle(_ faceSize: CGSize, _ angle: CGFloat) -> CGFloat {
        let faceHeight: CGFloat = faceSize.height
        let faceWidth: CGFloat = faceSize.width
        
        var workingRadius: CGFloat = 0
        
        let vx: CGFloat = cos(angle)
        let vy: CGFloat = sin(angle)
        
        let x1: CGFloat = 0
        let y1: CGFloat = 0
        let x2: CGFloat = faceHeight
        let y2: CGFloat = faceWidth
        let px: CGFloat = faceHeight / 2
        let py: CGFloat = faceWidth / 2
        
        var t: [CGFloat] = [0, 0, 0, 0]
        var smallestT: CGFloat = 1000
        
        t[0] = (x1 - px) / vx
        t[1] = (x2 - px) / vx
        t[2] = (y1 - py) / vy
        t[3] = (y2 - py) / vy
        
        for m in 0...3
            //        for (int m = 0; m < 4; m++)
        {
            let currentT: CGFloat = t[m]
            
            if (currentT > 0 && currentT < smallestT) {
                smallestT = currentT;
            }
            
        }
        
        workingRadius = smallestT;
        
        return workingRadius;
        
    }
    
    override init() {
        super.init()
    }
    
    private enum CodingKeys: String, CodingKey {
        case labelXMargin
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.labelXMargin = try container.decode(CGFloat.self, forKey: .labelXMargin)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(labelXMargin, forKey: .labelXMargin)
    }


}
