//
//  InterfaceController.swift
//  WatchClock3 WatchKit Extension
//
//  Created by 徐卫 on 2018/11/27.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import WatchKit

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var scene: WKInterfaceSKScene!
    
    private var curWeatchIndex: Int = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        self.curWeatchIndex = UserDefaults.standard.integer(forKey: "CurWatchIndex")
        self.loadCurWatch()
        
//        let watch = MyWatch()
//        scene.presentScene(watch.scene)
        
        // Configure interface objects here.
    }
    
    func loadCurWatch() -> Void {
        if self.curWeatchIndex < 0 || self.curWeatchIndex >= WatchManager.Manager.WatchList.count {
            self.curWeatchIndex = 0
        }
//        var lastscene = self.scene.scene as? WatchScene
//        if (lastscene != nil) {
//            lastscene?.watch?.stopTimer()
//        }

        var watch : MyWatch? = WatchManager.Manager.getWatch(index: self.curWeatchIndex)
        if (watch == nil) {
            watch = self.createDefaultWatch()
        }
        let currentDeviceSize: CGSize = WKInterfaceDevice.current().screenBounds.size
        watch?.scene.camera?.xScale = 184.0 / currentDeviceSize.width
        watch?.scene.camera?.yScale = 224 / currentDeviceSize.height
        watch?.BeginUpdate()
        watch?.EndUpdate()
        self.scene.presentScene(watch?.scene)
    }
    
    func createDefaultWatch() -> MyWatch {
        let watch = WatchManager.createWatch(backimage: "Hermes_watch_face_original", logoImage: "hermes_logo_white", hourImage: "Hermes_hours", minuteImage: "Hermes_minutes", secondImage: "Hermes_seconds")
        let layer = MoonLayer()
        layer.y = 45
        watch.addLayer(layer: layer)
        let textLayer = TextLayer.init(fontName: "HermesESPACE", FontSize: 48, Y: -90, backImage: "infoback1")
        watch.addLayer(layer: textLayer)
        watch.Settings.smoothHand = false
        return watch
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        IPhoneSessionUtil.shareManager.delegate = self
        IPhoneSessionUtil.shareManager.StartSession()
        IPhoneSessionUtil.shareManager.NotifyWatchActived()

    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    override func didAppear() {
        super.didAppear()
        
        let myApp = MyUIApplication()
        myApp.hideOSClock()
        
        self.crownSequencer.delegate = self
        self.crownSequencer.focus()
    }
    
    func refreshWatchSettings() -> Void {
        WatchManager.Manager.loadWatchFromFile()
        self.loadCurWatch()
    }

    private var totalRotation: Double = 0
    
    func NextWatch(_ dire : Int) -> Void {
        if (WatchManager.Manager.WatchList.count > 1) {
            self.curWeatchIndex = self.curWeatchIndex + dire
            if (curWeatchIndex >= WatchManager.Manager.WatchList.count) {
                self.curWeatchIndex = 0
            }
            if (curWeatchIndex < 0) {
                curWeatchIndex = WatchManager.Manager.WatchList.count - 1
            }
            UserDefaults.standard.set(self.curWeatchIndex, forKey: "CurWatchIndex")
            self.loadCurWatch()
        }
    }
}


extension InterfaceController : IPhoneSesionDelegate {
    func onReciveMsg(message: [String : Any]) -> [String : Any]? {
        if (message.count > 0) {
            for (key, value) in message {
                print("key = '\(key)")
                print("value = '\(value)")
//                if key.contains("_MD5") {
//                    continue
//                }
//                let md5Name = key + "_MD5"
//                if message[md5Name] != nil {
//                    let md5 = message[md5Name] as? String
//                    if let tmpStr = value as? String {
//                        print(tmpStr)
//                        print(tmpStr.count)
//                        let rmd5 = tmpStr.utf8.md5.rawValue
//                        print(md5)
//                        print(rmd5)
//                        if md5 != rmd5 {
//                            continue
//                        }
//                    }
//                }
                UserDefaults.standard.set(value, forKey: key)
            }
        }
        self.refreshWatchSettings()
        return ["Watch":"设置已更新，本次更新 " + String(WatchManager.Manager.WatchList.count) + " 个手表"]

    }
    
    
}

extension InterfaceController : WKCrownDelegate {
    

    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        
        var direction : Int = 1;
        
        totalRotation += fabs(rotationalDelta);
        
        if (rotationalDelta < 0) {
            direction = -1;
        }
        
        
        if (totalRotation > (Double.pi / 4)) {
            self.NextWatch(direction)
            totalRotation = 0;
        }
        
    }

}
