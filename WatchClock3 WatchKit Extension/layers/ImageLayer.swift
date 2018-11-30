//
//  ImageLayer.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/29.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class ImageLayer: WatchLayer {
    enum CodingKeys: String, CodingKey {
        case imageName
    }

    public var imageName: String = ""

    override func getLayerNode(layerNode : inout SKSpriteNode) -> Void {
        super.getLayerNode(layerNode: &layerNode)
        let texture = SKTexture.init(imageNamed: self.imageName)
        layerNode.texture = texture
        layerNode.size = texture.size()
        
    }
    
    override func getTitle() -> String {
        return "Image " + imageName
    }
    
    override func getImage() -> UIImage? {
        return UIImage.init(named: self.imageName)
    }

}
