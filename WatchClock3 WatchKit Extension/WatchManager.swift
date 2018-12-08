//
//  WatchManager.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/1.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import SpriteKit

class WatchManager {
    static let Manager: WatchManager = WatchManager()

    private init() {
        loadWatchFromFile()
    }

    var WatchList: [String] = []

    func loadWatchFromFile() -> Void {
        self.WatchList = []
        let num: Int = UserDefaults.standard.integer(forKey: "MyWatchNum")
        for i in 0..<num {
            if let jsonStr = UserDefaults.standard.string(forKey: "MyWatch" + String(i)) {
                print(jsonStr)
                self.WatchList.append(jsonStr)
//                if let watch = MyWatch.fromJSON(data: jsonStr) {
//                    self.WatchList.append(watch)
//                }
            }
        }
        self.WeatherLocation = UserDefaults.standard.string(forKey: "WeatherLocation") ?? ""
        self.WeatherCityName = UserDefaults.standard.string(forKey: "WeatherCityName") ?? ""
    }

    func saveWatchToFile() -> Void {
        UserDefaults.standard.set(WatchList.count, forKey: "MyWatchNum")
        for i in 0..<WatchList.count {
            let watch = WatchList[i]
            UserDefaults.standard.set(watch, forKey: "MyWatch" + String(i))
        }
        UserDefaults.standard.set(self.WeatherLocation, forKey: "WeatherLocation")
        UserDefaults.standard.set(self.WeatherCityName, forKey: "WeatherCityName")
    }
    
    func getWatch(index : Int) -> MyWatch? {
        if (index >= 0 && index < self.WatchList.count) {
            let jsonStr = self.WatchList[index]
            print(jsonStr)
            let watch = MyWatch.fromJSON(data: jsonStr)
            watch?.scene.updateWatch()
//            watch?.BeginUpdate()
//            watch?.EndUpdate()
            return watch
        }
        return nil
    }
    
    func addWatch(watchData : String) {
        let watchNum = self.WatchList.count
        self.WatchList.append(watchData)
        UserDefaults.standard.setValue(watchData, forKey: "MyWatch" + String(watchNum))
        UserDefaults.standard.setValue(self.WatchList.count, forKey: "MyWatchNum")
    }
    
    func updateWatch(index : Int,watchData : String) {
        if (index >= 0 && index < self.WatchList.count) {
            self.WatchList[index] = watchData
            UserDefaults.standard.setValue(watchData, forKey: "MyWatch" + String(index))
        }
    }
    
    func deleteWatch(index : Int) {
        if (index >= 0 && index < self.WatchList.count) {
            self.WatchList.remove(at: index)
            self.saveWatchToFile()
        }
    }
    
    //101180101
    var WeatherLocation: String = ""
    var WeatherCityName : String = ""
    
    
    class func createWatch(backimage : String,logoImage : String,hourImage : String,minuteImage : String,secondImage : String,logoColor : UIColor = UIColor.white) -> MyWatch {
        let watch = MyWatch()
        let bkLayer = ImageLayer()
        bkLayer.imageName = backimage
        watch.addLayer(layer: bkLayer)
        
        if logoImage != "" {
            let logoLayer = ImageLayer()
            logoLayer.imageName = logoImage
            logoLayer.y = 100
            logoLayer.fillColor.Color = logoColor
            logoLayer.fillWithColor = true
            watch.addLayer(layer: logoLayer)
        }
        
        
        let hLayer = HourLayer()
        hLayer.imageName = hourImage
        hLayer.anchorFromBottom = ResManager.Manager.getHandAnchorPoint(hourImage)
        watch.addLayer(layer: hLayer)
        
        if (minuteImage != "") {
            let mLayer = MinuteLayer()
            mLayer.imageName = minuteImage
            mLayer.anchorFromBottom = ResManager.Manager.getHandAnchorPoint(minuteImage)
            watch.addLayer(layer: mLayer)
        }
        
        if secondImage != "" {
            let sLayer = SecondsLayer()
            sLayer.imageName = secondImage
            sLayer.anchorFromBottom = ResManager.Manager.getHandAnchorPoint(secondImage)
            watch.addLayer(layer: sLayer)
        }
        
        
        return watch
    }
    
    class func createWatch(backimage : String,logoImage : String,hourImage : String,minuteImage : String,secondImage : String,colorRegionColor : UIColor,faceBackgroundColor: UIColor,alternateMajorMarkColor : UIColor,alterMinorMarkColor : UIColor,logoColor : UIColor = UIColor.white) -> MyWatch {
        
        let watch = WatchManager.createWatch(backimage: backimage, logoImage: logoImage, hourImage: hourImage, minuteImage: minuteImage, secondImage: secondImage,logoColor : logoColor)
        let layer = RectTickMarkLayer()
        layer.tickmarkStyle = .TickmarkStyleNone
        layer.numeralStyle = .NumeralStyleNone
        layer.alternateMajorMarkColor.Color = alternateMajorMarkColor
        layer.alternateMinorMarkColor.Color = alterMinorMarkColor
        watch.addLayer(layer: layer)
        
        watch.Settings.showColorRegion = true
        watch.Settings.backgroundColor.Color = faceBackgroundColor
        watch.Settings.ColorRegionColor.Color = colorRegionColor
        
        return watch
        
    }


}
