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
        case imageName = "in"
        case imageData = "id"
        case fillWithColor = "fwc"
        case fillColor = "fc"
    }

    public var imageName: String = ""

    override func setLayerNode(layerNode : inout SKSpriteNode) -> Void {
        super.setLayerNode(layerNode: &layerNode)
        if var image = self.getImage() {
            if self.fillWithColor {
                image = image.tint(color: self.fillColor.Color, blendMode: .destinationIn)
            }
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
        var image : UIImage?
        if self.imageData != nil {
            image =  UIImage.init(data: self.imageData!)
        } else {
            image = UIImage.init(named: self.imageName)
        }
        if self.fillWithColor {
            image = image?.tint(color: self.fillColor.Color, blendMode: .destinationIn)
        }
        return image
    }
    
    var fillWithColor : Bool = false
    var fillColor : MyColor = MyColor.init(color: UIColor.white)
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(fillWithColor, forKey: .fillWithColor)
        try container.encode(fillColor, forKey: .fillColor)
        if self.imageData != nil {
            try container.encode(imageData, forKey: .imageData)
        }
    }
    
    convenience init(imageName imagen : String,X : CGFloat,Y : CGFloat,scale : CGFloat = 1) {
        self.init()
        self.imageName = imagen
        self.x = X
        self.y = Y
        self.xScale = scale
        self.yScale = scale
    }
    
    override init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
//        print("ImageView init from decoder...")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageName = try container.decode(String.self, forKey: .imageName)
        self.fillWithColor = try container.decode(Bool.self, forKey: .fillWithColor)
        self.fillColor = try container.decode(MyColor.self, forKey: .fillColor)
        
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
