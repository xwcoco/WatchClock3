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
    private enum CodingKeys: String, CodingKey {
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
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(imageName, forKey: .imageName)

    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        print("ImageView init from decoder...")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageName = try container.decode(String.self, forKey: .imageName)
    }

}
