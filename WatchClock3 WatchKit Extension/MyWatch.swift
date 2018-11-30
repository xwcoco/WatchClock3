//
//  MyWatch.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/29.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class MyWatch : NSObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case backgroundColor
        case watchLayers
    }
    
    public var backgroundColor : MyColor = MyColor.init(color: UIColor.black)
    
    public var scene : WatchScene = WatchScene.init(fileNamed: "FaceScene")!
//    public var scene : WatchScene = WatchScene()
    
    override init() {
        super.init()
        scene.watch = self
    }
    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        backgroundColor = try container.decode(MyColor.self, forKey: .backgroundColor)
//    }

    
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
            self.scene.updateWatch()
        }
    }
    
    public func refreshWatch() {
        self.scene.needUpdate = true
    }
    
    public var hourHandLayer : WatchLayer?
    public var mintueHandLayer : WatchLayer?
    var secondsHandLayer : WatchLayer?
    
    func addLayer(layer : WatchLayer) -> Void {
        self.watchLayers.append(layer)
        if layer is HourLayer {
            self.hourHandLayer = layer
        }
        if layer is MinuteLayer {
            self.mintueHandLayer = layer
        }
        if layer is SecondsLayer {
            self.secondsHandLayer = layer
        }
    }
    
    func deleteLayer(layer : WatchLayer) -> Void {
        for i in 0..<self.watchLayers.count {
            let tmpLayer = self.watchLayers[i]
            if (tmpLayer === layer) {
                self.watchLayers.remove(at: i)
                
                if (layer is HourLayer) {
                    self.hourHandLayer = nil
                }
                if (layer is MinuteLayer) {
                    self.mintueHandLayer = nil
                }
                if (layer is SecondsLayer) {
                    self.secondsHandLayer = nil
                }
                
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
    
    public func toJSON() -> String {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8) ?? ""
        }
        catch {
            print(error)
        }
        return ""
        
    }
    
    private func initAfterFromJSON() {
        
    }
    
    public static func fromJSON(data: String) -> MyWatch? {
        if let jsonData: Data = data.data(using: .utf8) {
            do {
                let jsonDecoder = JSONDecoder()
                
                let json = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, Any>
                
                let watch = MyWatch()
                
                let backColorDict = json["backgroundColor"] as! Dictionary<String,Any>
                let backColorData = try JSONSerialization.data(withJSONObject: backColorDict, options: .prettyPrinted)
                
                let backColor = try jsonDecoder.decode(MyColor.self, from: backColorData)
                watch.backgroundColor.Color = backColor.Color

                let layers = json["watchLayers"] as! NSArray
                
                for key in layers {
                    if let tmpv = key as? Dictionary<String,Any> {
                        var className = tmpv["className"] as! String
                        className = Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + className
                        let aClass = NSClassFromString(className) as! WatchLayer.Type
                        let layerData = try JSONSerialization.data(withJSONObject: tmpv, options: .prettyPrinted)
                        let aLayer = try jsonDecoder.decode(aClass, from: layerData)
                        watch.addLayer(layer: aLayer)
                    }
                }
                return watch
                
            }
            catch {
                print(error)
            }
        }
        return nil
        
//        let jsonDecoder = JSONDecoder()
//        if let jsonData: Data = data.data(using: .utf8) {
//            do {
//                let watch = try jsonDecoder.decode(MyWatch.self, from: jsonData)
//                watch.initAfterFromJSON()
//                return watch
//            }
//            catch {
//                print(error)
//            }
//        }
//        return nil
    }
    
}
