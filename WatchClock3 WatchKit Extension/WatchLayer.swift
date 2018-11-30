//
//  WatchLayer.swift
//  WatchClock3 WatchKit Extension
//
//  Created by 徐卫 on 2018/11/27.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class WatchLayer : Codable {
    
    enum CodingKeys: String, CodingKey {
        case x
        case y
    }
    
    var x : CGFloat = 0
    var y : CGFloat = 0
    
    var alpha : CGFloat = 100
    
    func getLayerNode(layerNode : inout SKSpriteNode) -> Void {
        layerNode.position = CGPoint.init(x: x, y: y)
        layerNode.alpha = self.alpha
    }
    
    func getTitle() -> String {
        return ""
    }
    
    func getImage() -> UIImage? {
        return nil
    }
}

