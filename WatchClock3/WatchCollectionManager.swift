//
//  WatchCollectionManager.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/6.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class WatchCollItem {
    var category: String = ""

}

class WatchCollectionManager: NSObject {
    static var Manager: WatchCollectionManager = WatchCollectionManager()

    private override init() {
        super.init()
        self.createDefaultWatch()
    }

    private var watchCollections: NSMutableDictionary = NSMutableDictionary()


    private func createDefaultWatch() {
        self.createHermes()
        self.createNikes()
        self.createRolex()
        self.createColorWatch()
        self.createOtherWath()
    }

    func getWatchList(key: String) -> [MyWatch] {
        return self.watchCollections[key] as! [MyWatch]
    }

    func getWatchKeys() -> [String] {
        return self.watchCollections.allKeys as! [String]
    }
    
    func createWatch(backimage : String,logoImage : String,hourImage : String,minuteImage : String,secondImage : String) -> MyWatch {
        let watch = MyWatch()
        let bkLayer = ImageLayer()
        bkLayer.imageName = backimage
        watch.addLayer(layer: bkLayer)
        
        if logoImage != "" {
            let logoLayer = ImageLayer()
            logoLayer.imageName = logoImage
            logoLayer.y = 100
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
    
    func createWatch(backimage : String,logoImage : String,hourImage : String,minuteImage : String,secondImage : String,colorRegionColor : UIColor,faceBackgroundColor: UIColor,alternateMajorMarkColor : UIColor,alterMinorMarkColor : UIColor) -> MyWatch {

        let watch = self.createWatch(backimage: backimage, logoImage: logoImage, hourImage: hourImage, minuteImage: minuteImage, secondImage: secondImage)
        let layer = RectTickMarkLayer()
        layer.tickmarkStyle = .TickmarkStyleAll
        layer.numeralStyle = .NumeralStyleNone
        layer.alternateMajorMarkColor.Color = alternateMajorMarkColor
        layer.alternateMinorMarkColor.Color = alterMinorMarkColor
        watch.addLayer(layer: layer)
        
        watch.Settings.showColorRegion = true
        watch.Settings.backgroundColor.Color = faceBackgroundColor
        watch.Settings.ColorRegionColor.Color = colorRegionColor
        
        return watch
        
    }

    private func createHermes() {
        var watchList: [MyWatch] = []
        var watch = self.createWatch(backimage: "Hermes_watch_face_original", logoImage: "hermes_logo_white", hourImage: "Hermes_hours", minuteImage: "Hermes_minutes", secondImage: "Hermes_seconds")
        var layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        var textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 48, Y: -90, backImage: "infoback1")
        watch.addLayer(layer: textLayer)
        watch.Settings.smoothHand = true
        watchList.append(watch)

        watch = self.createWatch(backimage: "Hermes_watch_face_original_orange", logoImage: "hermes_logo_white", hourImage: "Hermes_hours_white", minuteImage: "Hermes_minutes_white", secondImage: "Hermes_seconds_orange")
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 48, Y: -90, backImage: "infoback1")
        watch.addLayer(layer: textLayer)
        watchList.append(watch)

        watch = self.createWatch(backimage: "Hermes_watch_face_classic", logoImage: "hermes_logo_white", hourImage: "Hermes_hours", minuteImage: "Hermes_minutes", secondImage: "Hermes_seconds")
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 48, Y: -90, backImage: "infoback1")
        watch.addLayer(layer: textLayer)
        watchList.append(watch)

        watch = self.createWatch(backimage: "Hermes_watch_face_classic_orange", logoImage: "hermes_logo_white", hourImage: "Hermes_hours_white", minuteImage: "Hermes_minutes_white", secondImage: "Hermes_seconds_orange")
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 48, Y: -90, backImage: "infoback1")
        watch.addLayer(layer: textLayer)
        watchList.append(watch)


        watch = self.createWatch(backimage: "Hermes_watch_face_standard", logoImage: "hermes_logo_white", hourImage: "Hermes_hours", minuteImage: "Hermes_minutes", secondImage: "Hermes_seconds")
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 48, Y: -90, backImage: "infoback1")
        watch.addLayer(layer: textLayer)
        watchList.append(watch)

        watch = self.createWatch(backimage: "Hermes_watch_face_standard_orange", logoImage: "hermes_logo_white", hourImage: "Hermes_hours_white", minuteImage: "Hermes_minutes_white", secondImage: "Hermes_seconds_orange")
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 48, Y: -90, backImage: "infoback1")
        watch.addLayer(layer: textLayer)
        watchList.append(watch)


        watch = self.createWatch(backimage: "Hermes_watch_face_roma", logoImage: "hermes_logo_white", hourImage: "Hermes_hours", minuteImage: "Hermes_minutes", secondImage: "Hermes_seconds")
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 48, Y: -90, backImage: "infoback1")
        watch.addLayer(layer: textLayer)
        watchList.append(watch)


        watch = self.createWatch(backimage: "Hermes_watch_face_roma_orange", logoImage: "hermes_logo_white", hourImage: "Hermes_hours_white", minuteImage: "Hermes_minutes_white", secondImage: "Hermes_seconds_orange")
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 48, Y: -90, backImage: "infoback1")
        watch.addLayer(layer: textLayer)
        watchList.append(watch)

        self.watchCollections.setValue(watchList, forKey: "Hermes")

    }

    private func createNikes() {
        var watchList: [MyWatch] = []
        
        var watch = self.createWatch(backimage: "Nike_watch_face_red", logoImage: "", hourImage: "Nike_hours", minuteImage: "Nike_minutes", secondImage: "Nike_seconds")
        watchList.append(watch)

        watch = self.createWatch(backimage: "Nike_watch_face_green", logoImage: "", hourImage: "Nike_hours", minuteImage: "Nike_minutes", secondImage: "Nike_seconds")
        watchList.append(watch)
        
        watch = self.createWatch(backimage: "Nike_watch_face_blue", logoImage: "", hourImage: "Nike_hours", minuteImage: "Nike_minutes", secondImage: "Nike_seconds")
        watchList.append(watch)

        watch = self.createWatch(backimage: "Nike_watch_face_pink", logoImage: "", hourImage: "Nike_hours", minuteImage: "Nike_minutes", secondImage: "Nike_seconds")
        watchList.append(watch)

        watch = self.createWatch(backimage: "Nike_watch_face_greenblue", logoImage: "", hourImage: "Nike_hours", minuteImage: "Nike_minutes", secondImage: "Nike_seconds")
        watchList.append(watch)
        
        watch = self.createWatch(backimage: "Nike_watch_face_black", logoImage: "", hourImage: "Nike_hours", minuteImage: "Nike_minutes", secondImage: "Nike_seconds")
        watchList.append(watch)

        watch = self.createWatch(backimage: "Nike_watch_face_grey", logoImage: "", hourImage: "Nike_hours_red", minuteImage: "Nike_minutes_red", secondImage: "Nike_seconds")
        watchList.append(watch)

        watch = self.createWatch(backimage: "Nike_watch_face_night", logoImage: "", hourImage: "Nike_hours", minuteImage: "Nike_minutes", secondImage: "Nike_seconds_orange")
        watchList.append(watch)

        self.watchCollections.setValue(watchList, forKey: "Nike")

    }
    
    func createRolex() -> Void {
        var watchList: [MyWatch] = []
        
        var watch = self.createWatch(backimage: "Rolex_watch_face_black_gold", logoImage: "rolex_logo_gold", hourImage: "Rolex_hours_gold", minuteImage: "Rolex_minutes_gold", secondImage: "Rolex_seconds_gold")
        watchList.append(watch)

        watch = self.createWatch(backimage: "Rolex_watch_face_luminous", logoImage: "rolex_logo_gold", hourImage: "Rolex_hours_luminous", minuteImage: "Rolex_minutes_luminous", secondImage: "Rolex_seconds_luminous")
        watchList.append(watch)
        
        watch = self.createWatch(backimage: "Rolex_watch_face_blue", logoImage: "rolex_logo_gold", hourImage: "Rolex_hours_gold", minuteImage: "Rolex_minutes_gold", secondImage: "Rolex_seconds_gold")
        watchList.append(watch)

        watch = self.createWatch(backimage: "Rolex_watch_face_green", logoImage: "rolex_logo_gold", hourImage: "Rolex_hours_gold", minuteImage: "Rolex_minutes_gold", secondImage: "Rolex_seconds_gold")
        watchList.append(watch)

//        watch = self.createWatch(backimage: "Rolex_watch_face_black_silver", logoImage: "rolex_logo_white", hourImage: "Rolex_hours_gold", minuteImage: "Rolex_minutes_gold", secondImage: "Rolex_seconds_gold")
//        watchList.append(watch)

        watch = self.createWatch(backimage: "Rolex_watch_face_black_white", logoImage: "rolex_logo_white", hourImage: "Rolex_hours_white", minuteImage: "Rolex_minutes_white", secondImage: "Rolex_seconds_white")
        watchList.append(watch)

        self.watchCollections.setValue(watchList, forKey: "Rolex")

    }
    
    func createColorWatch() -> Void {
        var watchList: [MyWatch] = []
        
        let alternateMajorMarkColor = UIColor.init(white: 1, alpha: 0.8)
        
        var watch = self.createWatch(backimage: "Hermes_watch_face_original", logoImage: "hermes_logo_white", hourImage: "HermesDoubleclour_H_Orange", minuteImage: "HermesDoubleclour_M_Orange", secondImage: "", colorRegionColor: UIColor.init(red: 0.892, green: 0.825, blue: 0.745, alpha: 1), faceBackgroundColor: UIColor.init(red: 0.118, green: 0.188, blue: 0.239, alpha: 1), alternateMajorMarkColor: UIColor.init(red: 1, green: 0.506, blue: 0, alpha: 1), alterMinorMarkColor: alternateMajorMarkColor)
        var layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        var textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 40, Y: -90, backImage: "info_back_3")
        watch.addLayer(layer: textLayer)
        watch.Settings.smoothHand = true
        watchList.append(watch)
        
        watch = self.createWatch(backimage: "Hermes_watch_face_original", logoImage: "hermes_logo_white", hourImage: "HermesDoubleclour_H_Orange", minuteImage: "HermesDoubleclour_M_Orange", secondImage: "", colorRegionColor: UIColor.init(red: 0.067, green: 0.420, blue: 0.843, alpha: 1), faceBackgroundColor: UIColor.init(red: 0.956, green: 0.137, blue: 0.294, alpha: 1), alternateMajorMarkColor: UIColor.init(red: 1, green: 0.506, blue: 0, alpha: 1), alterMinorMarkColor: alternateMajorMarkColor)
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 40, Y: -90, backImage: "info_back_3")
        watch.addLayer(layer: textLayer)
        watch.Settings.smoothHand = true
        watchList.append(watch)

        watch = self.createWatch(backimage: "Hermes_watch_face_original", logoImage: "hermes_logo_white", hourImage: "HermesDoubleclour_H_Orange", minuteImage: "HermesDoubleclour_M_Orange", secondImage: "", colorRegionColor: UIColor.init(white: 0.3, alpha: 1), faceBackgroundColor: UIColor.black, alternateMajorMarkColor: UIColor.init(red: 1, green: 0.506, blue: 0, alpha: 1), alterMinorMarkColor: alternateMajorMarkColor)
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 40, Y: -90, backImage: "info_back_3")
        watch.addLayer(layer: textLayer)
        watch.Settings.smoothHand = true
        watchList.append(watch)

        watch = self.createWatch(backimage: "Hermes_watch_face_original", logoImage: "hermes_logo_white", hourImage: "HermesDoubleclour_H_Orange", minuteImage: "HermesDoubleclour_M_Orange", secondImage: "", colorRegionColor: UIColor.init(red: 0.749, green: 0.291, blue: 0.319, alpha: 1), faceBackgroundColor: UIColor.init(red: 0.391, green: 0.382, blue: 0.340, alpha: 1), alternateMajorMarkColor: UIColor.init(red: 1, green: 0.506, blue: 0, alpha: 1), alterMinorMarkColor: alternateMajorMarkColor)
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 40, Y: -90, backImage: "info_back_3")
        watch.addLayer(layer: textLayer)
        watch.Settings.smoothHand = true
        watchList.append(watch)

        watch = self.createWatch(backimage: "Hermes_watch_face_original", logoImage: "hermes_logo_white", hourImage: "HermesDoubleclour_H_Orange", minuteImage: "HermesDoubleclour_M_Orange", secondImage: "", colorRegionColor: UIColor.init(red: 0.848, green: 0.187, blue: 0.349, alpha: 1), faceBackgroundColor: UIColor.init(red: 0.387, green: 0.226, blue: 0.270, alpha: 1), alternateMajorMarkColor: UIColor.init(red: 1, green: 1, blue: 0.812, alpha: 1), alterMinorMarkColor: alternateMajorMarkColor)
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 40, Y: -90, backImage: "info_back_3")
        watch.addLayer(layer: textLayer)
        watch.Settings.smoothHand = true
        watchList.append(watch)

        watch = self.createWatch(backimage: "Hermes_watch_face_original", logoImage: "hermes_logo_white", hourImage: "HermesDoubleclour_H_Orange", minuteImage: "HermesDoubleclour_M_Orange", secondImage: "", colorRegionColor: UIColor.init(red: 0.067, green: 0.471, blue: 0.651, alpha: 1), faceBackgroundColor: UIColor.init(red: 0.118, green: 0.188, blue: 0.239, alpha: 1), alternateMajorMarkColor: UIColor.init(red: 1, green: 0.506, blue: 0, alpha: 1), alterMinorMarkColor: alternateMajorMarkColor)
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 40, Y: -90, backImage: "info_back_3")
        watch.addLayer(layer: textLayer)
        watch.Settings.smoothHand = true
        watchList.append(watch)

        watch = self.createWatch(backimage: "Hermes_watch_face_original", logoImage: "hermes_logo_white", hourImage: "HermesDoubleclour_H_Orange", minuteImage: "HermesDoubleclour_M_Orange", secondImage: "", colorRegionColor: UIColor.init(red: 0.357, green: 0.678, blue: 0.600, alpha: 1), faceBackgroundColor: UIColor.init(red: 0.264, green: 0.346, blue: 0.321, alpha: 1), alternateMajorMarkColor: UIColor.init(red: 1, green: 0.506, blue: 0, alpha: 1), alterMinorMarkColor: alternateMajorMarkColor)
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 40, Y: -90, backImage: "info_back_3")
        watch.addLayer(layer: textLayer)
        watch.Settings.smoothHand = true
        watchList.append(watch)

        watch = self.createWatch(backimage: "Hermes_watch_face_original", logoImage: "hermes_logo_white", hourImage: "HermesDoubleclour_H_Orange", minuteImage: "HermesDoubleclour_M_Orange", secondImage: "", colorRegionColor: UIColor.init(red: 0.086, green: 0.584, blue: 0.706, alpha: 1), faceBackgroundColor: UIColor.init(white: 0.9, alpha: 1), alternateMajorMarkColor: UIColor.init(red: 1, green: 0.506, blue: 0, alpha: 1), alterMinorMarkColor: alternateMajorMarkColor)
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 40, Y: -90, backImage: "info_back_3")
        watch.addLayer(layer: textLayer)
        watch.Settings.smoothHand = true
        watchList.append(watch)


        watch = self.createWatch(backimage: "Hermes_watch_face_original", logoImage: "hermes_logo_white", hourImage: "HermesDoubleclour_H_Orange", minuteImage: "HermesDoubleclour_M_Orange", secondImage: "", colorRegionColor: UIColor.init(red: 0.118, green: 0.188, blue: 0.239, alpha: 1), faceBackgroundColor: UIColor.init(white: 0.9, alpha: 1), alternateMajorMarkColor: UIColor.init(red: 1, green: 0.506, blue: 0, alpha: 1), alterMinorMarkColor: alternateMajorMarkColor)
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 40, Y: -90, backImage: "info_back_3")
        watch.addLayer(layer: textLayer)
        watch.Settings.smoothHand = true
        watchList.append(watch)
        
        
        watch = self.createWatch(backimage: "Hermes_watch_face_original", logoImage: "hermes_logo_white", hourImage: "HermesDoubleclour_H_Orange", minuteImage: "HermesDoubleclour_M_Orange", secondImage: "", colorRegionColor: UIColor.init(red: 0.886, green: 0.141, blue: 0.196, alpha: 1), faceBackgroundColor: UIColor.init(red: 0.145, green: 0.157, blue: 0.176, alpha: 1), alternateMajorMarkColor: UIColor.init(red: 1, green: 0.506, blue: 0, alpha: 1), alterMinorMarkColor: alternateMajorMarkColor)
        layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 40, Y: -90, backImage: "info_back_3")
        watch.addLayer(layer: textLayer)
        watch.Settings.smoothHand = true
        watchList.append(watch)


        self.watchCollections.setValue(watchList, forKey: "Color")
    }
    
    func createOtherWath() -> Void {
        let watch = MyWatch()
        let imageLayer = ImageLayer()
        imageLayer.imageName = "casio_dw_face_1"
        imageLayer.xScale = 0.7
        imageLayer.yScale = 0.7
        watch.addLayer(layer: imageLayer)
        
        let timeLayer = TextLayer.init(fontName: "Let's go Digital", FontSize: 67, Y: 22, backImage: "")
        timeLayer.x = -34
        timeLayer.textContent = .TextContentTime2
        timeLayer.textColor.Color = UIColor.black
        watch.addLayer(layer: timeLayer)
        
        let secondLayer = TextLayer.init(fontName: "Let's go Digital", FontSize: 44, Y: 19, backImage: "")
        secondLayer.x = 65
        secondLayer.textContent = .TextContentTime3
        secondLayer.textColor.Color = UIColor.black
        watch.addLayer(layer: secondLayer)
        
        let wlayer = WeatherLayer()
        wlayer.showTempUnit = false
        wlayer.showWeatherIcon = true
        wlayer.textColor.Color = UIColor.black
        wlayer.weatherIconColor.Color = UIColor.black
        wlayer.fontName = "Let's go Digital"
        wlayer.fontSize = 33
        wlayer.x = -70
        wlayer.y = -29
        wlayer.weatherIconSize = 40
        watch.addLayer(layer: wlayer)
        
        let layer2 = WeatherLayer()
        layer2.weatherContent = .WeatherContentType
        layer2.x = 15
        layer2.y = -29
        layer2.fontName = "Let's go Digital"
        layer2.fontSize = 26
        layer2.textColor.Color = UIColor.black
        watch.addLayer(layer: layer2)
        
        let layer3 = WeatherLayer()
        layer3.weatherContent = .WeatherContentAQI
        layer3.x = 75
        layer3.y = -30
        layer3.fontName = "Let's go Digital"
        layer3.fontSize = 31
        layer3.textColor.Color = UIColor.black
        watch.addLayer(layer: layer3)

        
        
        var watchList : [MyWatch] = []
        watchList.append(watch)
        self.watchCollections.setValue(watchList, forKey: "Other")
        
    }

}
