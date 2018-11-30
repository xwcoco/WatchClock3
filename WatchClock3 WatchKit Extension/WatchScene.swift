//
//  WatchBaseScene.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/27.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class WatchScene: SKScene,SKSceneDelegate {
    var watch : MyWatch?
    
    func getLayerNode(index : Int) -> SKSpriteNode? {
        if self.face == nil {
            self.face = self.childNode(withName: "Face")
        }
        
        if (self.face == nil) {
            return nil
        }
        
        let node = self.face!.childNode(withName: "layer" + String(index)) as? SKSpriteNode
        return node
    }
    
    private var face : SKNode?
    
    private func hideAllLayer() {
        for i in 0..<50 {
            if let node = self.getLayerNode(index: i) {
                node.alpha = 0
            }
        }
    }
    
    func updateWatch() -> Void {
        if self.watch == nil {
            return
        }
        
        self.hideAllLayer()
        
        for i in 0..<watch!.watchLayers.count {
            let layer = self.watch!.watchLayers[i]
            var layerNode = self.getLayerNode(index: i)
            if (layerNode != nil) {
                layerNode?.alpha = 1
                layer.getLayerNode(layerNode: &layerNode!)
            } else {
                print("can't find layer",i)
            }
        }
    }
    
    var needUpdate : Bool = false
    
    override func update(_ currentTime: TimeInterval) {
        if self.needUpdate {
            self.updateWatch()
            self.needUpdate = false
        }
    }
    
    
    
}
