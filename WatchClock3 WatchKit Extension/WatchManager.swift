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
    }

    func saveWatchToFile() -> Void {
        UserDefaults.standard.set(WatchList.count, forKey: "MyWatchNum")
        for i in 0..<WatchList.count {
            let watch = WatchList[i]
            UserDefaults.standard.set(watch, forKey: "MyWatch" + String(i))
        }
    }
    
    func getWatch(index : Int) -> MyWatch? {
        if (index >= 0 && index < self.WatchList.count) {
            let jsonStr = self.WatchList[index]
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
}
