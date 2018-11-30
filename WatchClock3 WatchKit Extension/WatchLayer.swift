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

class WatchLayer : NSObject, Codable {
    
    private enum CodingKeys: String, CodingKey {
        case x
        case y
        case className
        case alpha
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(className, forKey: .className)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encode(alpha, forKey: .alpha)

    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        x = try container.decode(CGFloat.self, forKey: .x)
        y = try container.decode(CGFloat.self, forKey: .y)
        do {
            alpha = try container.decode(CGFloat.self, forKey: .alpha)
        }
        catch {
            alpha = 100
        }
        
    }
    
}

