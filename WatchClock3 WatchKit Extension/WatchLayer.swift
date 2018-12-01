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
        case xScale
        case yScale
    }
    
   
    var x : CGFloat = 0
    var y : CGFloat = 0
    
    var alpha : CGFloat = 1
    
    var xScale : CGFloat = 1
    var yScale : CGFloat = 1
    
    var scene : WatchScene?
    var watch : MyWatch?
    
    func getLayerNode(layerNode : inout SKSpriteNode) -> Void {
        layerNode.position = CGPoint.init(x: x, y: y)
        layerNode.alpha = self.alpha
        layerNode.xScale = self.xScale
        layerNode.yScale = self.yScale
    }
    
    func getTitle() -> String {
        return ""
    }
    
    func getTag() -> Int {
        return 0
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
        try container.encode(xScale, forKey: .xScale)
        try container.encode(yScale, forKey: .yScale)

    }
    
    var name : String = ""
    
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
            alpha = 1
        }
        do {
            xScale = try container.decode(CGFloat.self, forKey: .xScale)
        }
        catch {
            xScale = 1
        }
        do {
            yScale = try container.decode(CGFloat.self, forKey: .yScale)
        }
        catch {
            yScale = 1
        }
        
    }
    
    static var HourHandTag  : Int = 2
    static var MinuteHandTag : Int = 3
    static var SecondHandTag : Int = 4
    static var TickMarkTag : Int = 5
    
    
}

