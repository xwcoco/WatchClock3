//
//  HourLayer.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/30.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import SpriteKit

class HourLayer : ImageLayer {
    
    private enum CodingKeys: String, CodingKey {
        case anchorFromBottom = "afb"
    }
    
    override func getTitle() -> String {
        return "hour " + self.imageName
    }
    
    func getZPostion() -> CGFloat {
        return 800
    }
    
    override func setLayerNode(layerNode: inout SKSpriteNode) {
        super.setLayerNode(layerNode: &layerNode)
        var height = layerNode.size.height
        if height == 0 {
            height = 100
        }
        layerNode.anchorPoint = CGPoint(x: 0.5, y: self.anchorFromBottom / height)
        layerNode.zPosition = self.getZPostion()
    }
    
    var anchorFromBottom : CGFloat  = 18
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(anchorFromBottom, forKey: .anchorFromBottom)
        
    }
    
    convenience init(imageName name : String,X : CGFloat,Y : CGFloat,anchorFromBottom afb : CGFloat) {
        self.init(imageName: name, X: X, Y: Y)
        self.anchorFromBottom = afb
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
//        print("HourLayer init from decoder...")
        try super.init(from: decoder)
       
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.anchorFromBottom = try container.decode(CGFloat.self, forKey: .anchorFromBottom)
    }
    
    override func getTag() -> Int {
        return WatchLayer.HourHandTag
    }
}


class MinuteLayer: HourLayer {
    override func getTitle() -> String {
        return "Minute " + self.imageName
    }
    
    override func getTag() -> Int {
        return WatchLayer.MinuteHandTag
    }
    
    override func getZPostion() -> CGFloat {
        return 850
    }
}

class SecondsLayer : HourLayer {
    override func getTitle() -> String {
        return "Seconds " + self.imageName
    }
    
    override func getTag() -> Int {
        return WatchLayer.SecondHandTag
    }
    
    override func getZPostion() -> CGFloat {
         return 900
    }
}
