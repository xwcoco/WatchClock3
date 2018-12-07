//
//  MoonLayer.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/5.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import SpriteKit

class MoonLayer : WatchLayer {
    override func getTag() -> Int {
        return 11
    }
    
    override func getTitle() -> String {
        return NSLocalizedString("Moon", comment: "")
    }
    
    override func getImage() -> UIImage? {
        let index = self.getMoonIndex()
        var img = UIImage.init(named: "moon_"+String(index))
//        img = img?.getTransImage()
        return img
    }
    
    func getMoonIndex() -> Int {
        let lunarCalendar = Calendar.init(identifier: .chinese)
        let day = lunarCalendar.component(.day, from: self.watch!.curDate)
        return day
    }
    
    override func setLayerNode(layerNode: inout SKSpriteNode) {
        super.setLayerNode(layerNode: &layerNode)
//        let index = self.getMoonIndex()
        if let image = self.getImage() {
            let texture = SKTexture.init(image: image)
            //        let texture = SKTexture.init(imageNamed: "moon_"+String(index))
            layerNode.texture = texture
            var size = texture.size()
            size = CGSize.init(width: size.width * self.xScale, height: size.height * self.yScale)
            layerNode.alpha = 1
            
            layerNode.size = size
        }
        

    }
    
    
}
