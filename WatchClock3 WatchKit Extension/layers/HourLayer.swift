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
        case anchorFromBottom
    }
    
    override func getTitle() -> String {
        return "hour " + self.imageName
    }
    
    override func getLayerNode(layerNode: inout SKSpriteNode) {
        super.getLayerNode(layerNode: &layerNode)
        var height = layerNode.size.height
        if height == 0 {
            height = 100
        }
        layerNode.anchorPoint = CGPoint(x: 0.5, y: self.anchorFromBottom / height)
    }
    
    var anchorFromBottom : CGFloat  = 18
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(anchorFromBottom, forKey: .anchorFromBottom)
        
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        print("HourLayer init from decoder...")
        try super.init(from: decoder)
       
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.anchorFromBottom = try container.decode(CGFloat.self, forKey: .anchorFromBottom)
    }
}


class MinuteLayer: HourLayer {
    override func getTitle() -> String {
        return "Minute " + self.imageName
    }
}

class SecondsLayer : HourLayer {
    override func getTitle() -> String {
        return "Seconds " + self.imageName
    }
}
