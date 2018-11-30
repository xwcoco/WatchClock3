//
//  MyWatch.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/29.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class MyWatch : Codable {
    
    enum CodingKeys: String, CodingKey {
        case backgroundColor
        case watchLayers
    }
    
    public var backgroundColor : MyColor = MyColor.init(color: UIColor.black)
    
    public var scene : WatchScene = WatchScene.init(fileNamed: "FaceScene")!
//    public var scene : WatchScene = WatchScene()
    
    init() {
        scene.watch = self
    }
    
    public var watchLayers : [WatchLayer] = []
    
    private var updateCount : Int = 0
    
    public func BeginUpdate() {
        self.updateCount = self.updateCount + 1
    }
    
    public func EndUpdate() {
        self.updateCount = self.updateCount - 1
        if (self.updateCount < 0) {
            self.updateCount = 0
        }
        if (self.updateCount == 0) {
            self.scene.needUpdate = true
        }
    }
    
    public func refreshWatch() {
        self.scene.needUpdate = true
    }
    
    public var hourHandLayer : WatchLayer?
    
    func addLayer(layer : WatchLayer) -> Void {
        self.watchLayers.append(layer)
        if layer is HourLayer {
            self.hourHandLayer = layer
        }
    }
    
    func deleteLayer(layer : WatchLayer) -> Void {
        for i in 0..<self.watchLayers.count {
            let tmpLayer = self.watchLayers[i]
            if (tmpLayer === layer) {
                self.watchLayers.remove(at: i)
                return
            }
        }
    }
    
    func getLayer(index : Int) -> WatchLayer? {
        if (index >= 0 && index < self.watchLayers.count) {
            return self.watchLayers[index]
        }
        return nil
    }
}
