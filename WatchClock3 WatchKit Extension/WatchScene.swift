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
        let node = self.face?.childNode(withName: "layer" + String(index)) as? SKSpriteNode
        return node
    }
    
   
    
    private func hideAllLayer() {
        for i in 0..<50 {
            if let node = self.getLayerNode(index: i) {
                node.alpha = 0
                node.texture = nil
                node.zPosition = 0
                node.removeAllChildren()
            }
        }
        while self.children.count > 2 {
            let node = self.children[2]
            node.removeFromParent()
        }
    }
    
    var face : SKNode?
    
    var colorRegion : SKSpriteNode?
    var colorRegionReflection : SKSpriteNode?

    func getInitNode() -> Void {
        self.face = self.childNode(withName: "Face")
        colorRegion = face?.childNode(withName: "Color Region") as? SKSpriteNode
        colorRegionReflection = face?.childNode(withName: "Color Region Reflection") as? SKSpriteNode
    }
    
    func updateWatch() -> Void {
        if self.watch == nil {
            return
        }
        
        self.hideAllLayer()
        
        self.backgroundColor = watch!.Settings.backgroundColor.Color
        
        
        if (watch!.Settings.showColorRegion) {
            colorRegion?.alpha = 1
            colorRegion?.colorBlendFactor = 1
            colorRegion?.color = watch!.Settings.ColorRegionColor.Color
            colorRegion?.colorBlendFactor = 1
            colorRegionReflection?.alpha = 1
            colorRegionReflection?.colorBlendFactor = 1
        } else {
            colorRegion?.alpha = 0
            colorRegionReflection?.alpha = 0
        }

        
        for i in 0..<watch!.watchLayers.count {
            let layer = self.watch!.watchLayers[i]
            var layerNode = self.getLayerNode(index: i)
            if (layerNode != nil) {
                layerNode?.alpha = 1
                layer.setLayerNode(layerNode: &layerNode!)
            } else {
                print("can't find layer",i)
            }
        }
        
    }
    
    var needUpdate : Bool = false
    var lastHour : Int = -1
    var lastMinute : Int = -1
    var lastSecond : Int = -1
    
    override func update(_ currentTime: TimeInterval) {
        if self.needUpdate {
            self.updateWatch()
            self.needUpdate = false
            return
        }
        
        self.watch?.checkForUpdate()
        
        if watch!.Settings.smoothHand {
            self.updateHands()
//        } else if self.watch!.dateChanged {
//            self.updateClock()
//            self.watch!.dateChanged = false
        } else {
            self.watch?.UpdateTime()
            let hour = self.watch?.getDateValue(.hour)
            let minute = self.watch?.getDateValue(.minute)
            let seconds = self.watch?.getDateValue(.second)
            
            if (hour != self.lastHour || minute != self.lastMinute || seconds != self.lastSecond) {
                self.lastHour = hour!
                self.lastMinute = minute!
                self.lastSecond = seconds!
                
                self.updateClock()
            }
            
        }
        
        if self.watch!.isDemoMode {
            self.checkDemo()
        }
    }
    
    private func checkDemo() {
        #if os(iOS)
        self.watch!.demoCount = self.watch!.demoCount + 1
        if (watch!.demoCount > 5) {
            watch!.isPaused = true
            self.view?.isPaused = true
        }
        #endif
    }
    
    private func getLayerNode(layer : WatchLayer?) -> SKNode? {
        if (layer == nil) {
            return nil
        }
        let index = self.watch!.getLayerIndex(layer: layer!)
        return self.getLayerNode(index: index)
    }
    
    func updateHands() -> Void {
        let calendar = NSCalendar.current
        let currentDate = Date()
        
        let hour: Int = calendar.component(.hour, from: currentDate)
        let minute: Int = calendar.component(.minute, from: currentDate)
        let second: Int = calendar.component(.second, from: currentDate)
        let nanosecond = calendar.component(.nanosecond, from: currentDate)
        
        self.updateClockHand(hour: hour, minute: minute, second: second,nanosecond : nanosecond)
    }
    
   
    private func updateClockHand(hour : Int,minute : Int,second : Int,nanosecond : Int) {
//        let face: SKNode? = self.childNode(withName: "Face")
        
//        let hourHand: SKNode? = self.getHandNode(layer: self.watch?.hourHandLayer)
//        let minuteHand: SKNode? = self.getHandNode(layer: self.watch?.mintueHandLayer)
//        let secondHand: SKNode? = self.getHandNode(layer: self.watch?.secondsHandLayer)
        

        var tmpv: CGFloat = CGFloat(hour % 12) + 1.0 / 60.0 * CGFloat(minute)
        let hourHands = self.watch!.getLayersByTag(WatchLayer.HourHandTag)
        for hourHand in hourHands {
            let node = self.getLayerNode(layer: hourHand)
            node?.zRotation = -(2 * CGFloat.pi) / 12.0 * tmpv
        }
        
        
        tmpv = CGFloat(minute) + 1.0 / 60.0 * CGFloat(second)
        let minuteHands = self.watch!.getLayersByTag(WatchLayer.MinuteHandTag)
        for minuteLayer in minuteHands {
            let minuteHand = self.getLayerNode(layer: minuteLayer)
            minuteHand?.zRotation = -(2 * CGFloat.pi) / 60.0 * tmpv
        }
        
        tmpv = CGFloat(second) + 1.0 / 1000000000.0 * CGFloat(nanosecond)
        
        let secondLayers = self.watch!.getLayersByTag(WatchLayer.SecondHandTag)
        for secondLayer in secondLayers {
            let secondHand = self.getLayerNode(layer: secondLayer)
            secondHand?.zRotation = -(2 * CGFloat.pi) / 60 * tmpv
        }
        
        tmpv = CGFloat(minute) + 1.0 / 60.0 * CGFloat(second)
        colorRegion?.zRotation = CGFloat.pi / 2 - (2 * CGFloat.pi) / 60.0 * tmpv
        
        tmpv = CGFloat(minute) + 1.0 / 60.0 * CGFloat(second)
        colorRegionReflection?.zRotation = CGFloat.pi / 2 - (2 * CGFloat.pi) / 60.0 * tmpv
    }
    
    func updateClock() -> Void {
        let hour: Int = self.watch!.getDateValue(.hour)
        let minute: Int = self.watch!.getDateValue(.minute)
        let second: Int = self.watch!.getDateValue(.second)
        let nanosecond = self.watch!.getDateValue(.nanosecond)
        
        self.updateClockHand(hour: hour, minute: minute, second: second,nanosecond : nanosecond)

    }
}
