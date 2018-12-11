//
//  DateImageLayer.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/9.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import SpriteKit

class DateImageLayer : WatchLayer {
    override func getTag() -> Int {
        return 12
    }
    
    override func getTitle() -> String {
        return "Date Image"
    }
    
    var pointerImage : String = ""
    var pointerImageColor : MyColor = MyColor.init(color: UIColor.clear)
    
    var beginAngle : CGFloat = 0
    var startAngle : CGFloat = 0
    var endAngle : CGFloat = 360
    
    
    override func setLayerNode(layerNode: inout SKSpriteNode) {
        super.setLayerNode(layerNode: &layerNode)
        if let node = self.createNode() {
            layerNode.addChild(node)
        }
        layerNode.size = CGSize.zero
    }
    
    override func getImage() -> UIImage? {
        #if os(iOS)
        if self.scene?.view != nil {
            if let node = self.createNode() {
                if let texture = self.scene?.view?.texture(from: node) {
                    let image = UIImage.init(cgImage: texture.cgImage())
                    return image
                }
            }
        }
        return nil
        #else
        return nil
        #endif
    }
    
    private func createNode() -> SKSpriteNode? {
        if self.pointerImage != "" {
            var image = UIImage.init(named: pointerImage)
            image = image?.tint(color: self.pointerImageColor.Color, blendMode: .destinationIn)
            let texture = SKTexture.init(image: image!)
            let node = SKSpriteNode.init(texture: texture)
            var size = texture.size()
            
            let bp = ResManager.Manager.getHandAnchorPoint(self.pointerImage)
            let bpp = bp / size.height

            size = CGSize.init(width: size.width * self.xScale, height: size.height * self.yScale)
            node.size = size
            node.anchorPoint = CGPoint.init(x: 0.5, y: bpp)
            
            let angle = self.getDatePointAngle()
            node.zRotation = angle
            
            return node
        }
        
        return nil
    }
    
    func getDatePointAngle() -> CGFloat {
        let day = self.watch?.getDateValue(.day)
        let tmpv: CGFloat = CGFloat((day! - 1) * 2 + 1) / (31 * 2)
        return tmpv * (-2 * CGFloat.pi) * (self.endAngle - self.startAngle) / 360 + beginAngle / 180 * CGFloat.pi - self.startAngle / 180 * CGFloat.pi
    }
    
    private enum CodingKeys: String, CodingKey {
        case pointerImage = "pi"
        case pointerImageColor = "pic"
        case beginAngle = "ba"
        case startAngle = "sa"
        case endAngle = "ea"
    }
    
    convenience init(pointerImage bimage : String,X : CGFloat,Y : CGFloat,scale : CGFloat,beginAngle  bangle  : CGFloat = 0,startAngle sangle : CGFloat = 0,endAngle eangle : CGFloat = 360) {
        self.init()
        self.pointerImage = bimage
        self.x = X
        self.y = Y
        self.xScale = scale
        self.yScale = scale
        self.beginAngle = bangle
        self.startAngle = sangle
        self.endAngle = eangle
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pointerImage = try container.decode(String.self, forKey: .pointerImage)
        self.pointerImageColor = try container.decode(MyColor.self, forKey: .pointerImageColor)
        self.beginAngle = try container.decode(CGFloat.self, forKey: .beginAngle)
        self.startAngle = try container.decode(CGFloat.self, forKey: .startAngle)
        self.endAngle = try container.decode(CGFloat.self, forKey: .endAngle)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(pointerImage, forKey: .pointerImage)
        try container.encode(pointerImageColor, forKey: .pointerImageColor)
        try container.encode(beginAngle, forKey: .beginAngle)
        try container.encode(startAngle, forKey: .startAngle)
        try container.encode(endAngle, forKey: .endAngle)
    }
}

class WeekDayImageLayer : DateImageLayer {
    override func getTag() -> Int {
        return 13
    }
    
    override func getTitle() -> String {
        return "WeekDay Image"
    }
    
    override func getDatePointAngle() -> CGFloat {
        let day = self.watch?.getDateValue(.weekday)
        let tmpv: CGFloat = CGFloat((day! - 1) * 2 + 1) / 14
        return tmpv * (-2 * CGFloat.pi) * (self.endAngle - self.startAngle) / 360 + beginAngle / 180 * CGFloat.pi - self.startAngle / 180 * CGFloat.pi
    }

}

class MonthImageLayer : DateImageLayer {
    override func getTag() -> Int {
        return 14
    }
    
    override func getTitle() -> String {
        return "Month Image"
    }
    
    override func getDatePointAngle() -> CGFloat {
        let day = self.watch?.getDateValue(.month)
        let tmpv: CGFloat = CGFloat((day! - 1) * 2 ) / 24
        return tmpv * (-2 * CGFloat.pi) * (self.endAngle - self.startAngle) / 360 + beginAngle / 180 * CGFloat.pi - self.startAngle / 180 * CGFloat.pi
    }
    
}
