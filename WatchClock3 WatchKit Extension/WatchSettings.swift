//
//  WatchSettings.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/1.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import SpriteKit

class WatchSettings: NSObject,Codable {
    enum CodingKeys: String, CodingKey {
        case backgroundColor = "bc"
        case showColorRegion = "scr"
        case ColorRegionColor = "crc"
        case smoothHand = "sh"
    }
    
    var backgroundColor : MyColor = MyColor.init(color: UIColor.black)
    var showColorRegion : Bool = false
    var ColorRegionColor : MyColor = MyColor.init(color : UIColor.red)
    
    var smoothHand : Bool = false
    
}
