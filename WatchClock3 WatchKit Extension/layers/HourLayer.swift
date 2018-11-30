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
    
}
