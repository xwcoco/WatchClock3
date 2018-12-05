//
//  MagicLayer.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/4.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import SpriteKit

class MagicLayer : WatchLayer {
    override func getTag() -> Int {
        return 10
    }
    
    override func getTitle() -> String {
        return "Magic Layer"
    }
    
    override func setLayerNode(layerNode: inout SKSpriteNode) {
        super.setLayerNode(layerNode: &layerNode)
        
        layerNode.size = CGSize.zero
        if let node = self.createMagicNode() {
            layerNode.addChild(node)
        }
    }
    
    func createMagicNode() -> SKNode? {
        let node = SKEmitterNode.init(fileNamed: "MagicParticle.sks")
//        let node = SKEmitterNode.init(fileNamed: "RainParticle.sks")
        return node
    }
    
}
