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
        case imageData
    }

    public var imageName: String = ""

    override func setLayerNode(layerNode : inout SKSpriteNode) -> Void {
        super.setLayerNode(layerNode: &layerNode)
        if let image = self.getImage() {
            let texture = SKTexture.init(image: image)
            layerNode.texture = texture
            var size = texture.size()
            size = CGSize.init(width: size.width * self.xScale, height: size.height * self.yScale)
            layerNode.size = size
        }

    }
    
    var imageData : Data?
    
    override func getTitle() -> String {
        return "Image " + imageName
    }
    
    override func getImage() -> UIImage? {
        if self.imageData != nil {
            print(imageData?.count)
            return UIImage.init(data: self.imageData!)
        }
        return UIImage.init(named: self.imageName)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(imageName, forKey: .imageName)
        if self.imageData != nil {
            try container.encode(imageData, forKey: .imageData)
        }
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
//        print("ImageView init from decoder...")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageName = try container.decode(String.self, forKey: .imageName)
        do {
            self.imageData = try container.decode(Data.self, forKey: .imageData)
        }
        catch {
            
        }
    }
    
    override func getTag() -> Int {
        return 1
    }

}
