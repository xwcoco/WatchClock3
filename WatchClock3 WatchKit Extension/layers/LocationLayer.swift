//
//  LocationLayer.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/3.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import SpriteKit
import CoreLocation

class LocationLayer: TextLayer {
    override func getTag() -> Int {
        return 8
    }

    override func getTitle() -> String {
        return "location"
    }


    var location: CLLocation?

    override func getText() -> String {
        if location == nil {
            return ""
        }
        return String.init(format: "%.0fm", arguments: [location!.altitude])
    }

    override init() {
        super.init()
        self.initLocationData()
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        self.initLocationData()
    }

    private func initLocationData() {
        ResManager.Manager.initLocation()
        NotificationCenter.default.addObserver(forName: Notification.Name("LocationUpdate"), object: nil, queue: nil, using: setLocationData)
        self.location = ResManager.Manager.location
    }

    func setLocationData(noti: Notification) -> Void {
        self.location = ResManager.Manager.location
//        print("location data recived")
//        print(self.location)
        self.changed = true
    }

}


class ImageLocationLayer: LocationLayer {
    override func getTag() -> Int {
        return 9
    }

    override func getTitle() -> String {
        return "Image location"
    }

    override func getImage() -> UIImage? {
        #if os(iOS)
            if self.scene?.view != nil {
                if let node = self.createImageLocationNode() {
                    if let texture = self.scene?.view?.texture(from: node) {
                        let image = UIImage.init(cgImage: texture.cgImage())
                        return image
                    }
                }
            }
        #endif
        return nil
    }

    override init() {
        super.init()
        self.backImage = "altitude_bg2"
        self.fontSize = 16
        self.textColor.Color = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }



    override func setLayerNode(layerNode: inout SKSpriteNode) {
        self.exposeSetLayerNode(layerNode: &layerNode)
        layerNode.removeAllChildren()
        layerNode.size = CGSize.zero
        if let node = self.createImageLocationNode() {
            layerNode.addChild(node)
        }
    }

    func createImageLocationNode() -> SKSpriteNode? {

        if (self.backImage == "") {
            return nil
        }

        if self.location == nil {
            return nil
        }

        var maxV: Double = 100

        let tmpAltidue = self.location!.altitude
//        tmpAltidue = 100.2

        if tmpAltidue != 0 {
            let tmpStr = String.init(format: "%.0f", arguments: [tmpAltidue])
            let num = tmpStr.count
            var divNum: Int = 1
            for _ in 1..<num {
                divNum = divNum * 10
            }
            maxV = ceil(tmpAltidue / Double(divNum)) * Double(divNum)
        }

        let texture = SKTexture.init(imageNamed: self.backImage)

        let imageNode = SKSpriteNode()
        imageNode.texture = texture
        imageNode.size = texture.size()

        let tmpStr = String.init(format: "%.0f", maxV / 2)
        let font = self.getTextFont()
        let attr = self.getTextStyle(font: font, color: self.textColor.Color)
        let labelText: NSAttributedString = NSAttributedString(string: tmpStr, attributes: attr)

        let rect = self.getTextRect(text: tmpStr, attributes: attr)

        let textNode = SKLabelNode(attributedText: labelText)

        imageNode.addChild(textNode)
        textNode.position = CGPoint.init(x: 0, y: -imageNode.size.height / 2.0 + rect.height / 2)

        let tmpStr1 = String.init(format: "%.0f", maxV / 4)
        let rect1 = self.getTextRect(text: tmpStr1, attributes: attr)
        let textNode1 = SKLabelNode(attributedText: NSAttributedString(string: tmpStr1, attributes: attr))
        textNode1.position = CGPoint.init(x: imageNode.size.width / 2 - rect1.width, y: -rect1.height / 2)
        imageNode.addChild(textNode1)

        let tmpStr2 = String.init(format: "%.0f", maxV * 3 / 4)
        let rect2 = self.getTextRect(text: tmpStr2, attributes: attr)
        let textNode2 = SKLabelNode(attributedText: NSAttributedString(string: tmpStr2, attributes: attr))
        textNode2.position = CGPoint.init(x: -imageNode.size.width / 2 + rect2.width, y: -rect1.height / 2)
        imageNode.addChild(textNode2)


        let handNode = SKSpriteNode.init(imageNamed: "altitude_hand_thin")
        handNode.position = CGPoint.init(x: 0, y: 0)
        handNode.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        if maxV != 0 {
            handNode.zRotation = CGFloat(-tmpAltidue / maxV * Double.pi * 2)
        }
        imageNode.addChild(handNode)

        return imageNode
    }

}
