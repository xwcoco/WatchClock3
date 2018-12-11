//
//  BatteryImageLayer.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/9.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import SpriteKit

class BatteryImageLayer : DateImageLayer {
    override func getTag() -> Int {
        return 15
    }
    
    override func getTitle() -> String {
        return "Battery Image"
    }
    
    override func getDatePointAngle() -> CGFloat {
        let batteryLevel = self.getBattery()
        let angle = batteryLevel / 100
        return angle * (-2 * CGFloat.pi) * (self.endAngle - self.startAngle) / 360 + beginAngle / 180 * CGFloat.pi - self.startAngle / 180 * CGFloat.pi
    }
    
    func getBattery() -> CGFloat {
        #if os(watchOS)
        WKInterfaceDevice.current().isBatteryMonitoringEnabled = true
        return CGFloat(WKInterfaceDevice.current().batteryLevel * 100)
        #else
        UIDevice.current.isBatteryMonitoringEnabled = true
        return CGFloat(UIDevice.current.batteryLevel * 100)
        #endif
        
        
    }

}
