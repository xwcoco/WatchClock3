//
//  MyWatch.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/29.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class MyWatch: NSObject, Codable {

    enum CodingKeys: String, CodingKey {
        case Settings
        case watchLayers
    }

    var Settings: WatchSettings = WatchSettings()

    public var scene: WatchScene = WatchScene.init(fileNamed: "FaceScene")!

    override init() {
        super.init()
        scene.getInitNode()
        scene.watch = self

        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: self.onTimer)
    }

    private var idCounter: Int = 0

    func getNewId() -> Int {
        self.idCounter = self.idCounter + 1
        return self.idCounter
    }

    var calendar: Calendar = NSCalendar.current
    var curDate: Date = Date()

    var isPaused: Bool = false
    
    var isDemoMode : Bool = false {
        didSet {
            self.demoCount = 0
        }
    }
    
    var demoCount : Int = 0

    private func onTimer(_ time: Timer) -> Void {
        if self.isPaused {
            return
        }
        curDate = Date()
        if (!self.Settings.smoothHand) {

            for i in 0..<self.watchLayers.count {
                let layer = self.watchLayers[i]
                if layer.checkChanged() {
                    if var node = self.scene.getLayerNode(index: i) {
                        layer.setLayerNode(layerNode: &node)
                    }
                    layer.resetChanged()
                }
            }
            self.scene.updateClock()
        } else {
            for layer in self.watchLayers {
                if layer.checkChanged() {
                    self.scene.needUpdate = true
                    layer.resetChanged()
                }
            }
        }
        
        if self.isDemoMode {
            self.demoCount = self.demoCount + 1
            if self.demoCount > 5 {
                self.isPaused = true
            }
        }
        
    }

    func getDateValue(_ comp: Calendar.Component) -> Int {
        return self.calendar.component(comp, from: curDate)
    }

    private var timer: Timer?

    public var watchLayers: [WatchLayer] = []

    private var updateCount: Int = 0

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

    func addLayer(layer: WatchLayer) -> Void {
        layer.scene = self.scene
        layer.name = "layer" + String(self.getNewId())
        layer.watch = self
        self.watchLayers.append(layer)
    }

    func deleteLayer(index: Int) -> Void {
        if (index >= 0 && index < self.watchLayers.count) {
            let layer = self.watchLayers[index]
            layer.scene = nil
            self.watchLayers.remove(at: index)
        }
    }

    func deleteLayer(layer: WatchLayer) -> Void {
        for i in 0..<self.watchLayers.count {
            let tmpLayer = self.watchLayers[i]
            if (tmpLayer === layer) {
                self.deleteLayer(index: i)
                return
            }
        }
    }

    func getLayerIndex(layer: WatchLayer) -> Int {
        for i in 0..<self.watchLayers.count {
            let tmpLayer = self.watchLayers[i]
            if (tmpLayer === layer) {
                return i
            }
        }
        return -1
    }

    func getLayer(index: Int) -> WatchLayer? {
        if (index >= 0 && index < self.watchLayers.count) {
            return self.watchLayers[index]
        }
        return nil
    }

    func getLayersByTag(_ tag: Int) -> [WatchLayer] {
        var ret: [WatchLayer] = []
        for layer in self.watchLayers {
            if layer.getTag() == tag {
                ret.append(layer)
            }
        }
        return ret
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

                let setsDict = json["Settings"] as! Dictionary<String, Any>
                let setsData = try JSONSerialization.data(withJSONObject: setsDict, options: .prettyPrinted)
                watch.Settings = try jsonDecoder.decode(WatchSettings.self, from: setsData)

                let layers = json["watchLayers"] as! NSArray

                for key in layers {
                    if let tmpv = key as? Dictionary<String, Any> {
                        var className = tmpv["className"] as! String
                        className = Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + className
                        do {
                            let aClass = NSClassFromString(className) as? WatchLayer.Type
                            if aClass != nil {
                                let layerData = try JSONSerialization.data(withJSONObject: tmpv, options: .prettyPrinted)
                                let aLayer = try jsonDecoder.decode(aClass!, from: layerData)
                                watch.addLayer(layer: aLayer)
                            }
                        }
                        catch {
                            print(error)
                        }
                    }
                }
                return watch

            }
            catch {
                print(error)
            }
        }
        return nil

    }

    func snapShot() -> UIImage? {
        #if os(iOS)
            self.refreshWatch()
            if self.scene.view != nil {
                if let texture = self.scene.view?.texture(from: self.scene.face!) {
                    let image = UIImage.init(cgImage: texture.cgImage())
                    return image
                }
            }
            return nil
        #else
            return nil
        #endif
    }

}
