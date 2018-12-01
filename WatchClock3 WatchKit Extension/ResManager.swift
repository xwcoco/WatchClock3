//
//  ResManager.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/29.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit


class WatchRes {
    var category: String = ""
    var list: [String] = []
}

class ResManager: NSObject {
    static let Manager: ResManager = ResManager()

    private override init() {
        super.init()
        self.loadImageNamesFromAsset()
    }

    private var HandAnchorPoints: [String: CGFloat] = ["Hermes_minutes": 16,
                                                       "Hermes_minutes_white": 16,
                                                       "HermesDoubleclour_M_Orange": 18,
                                                       "HermesDoubleclour_M_Pink": 18,
                                                       "Nike_minutes": 17,
                                                       "Nike_minutes_red": 17,
                                                       "Rolex_minutes_gold": 17,
                                                       "Rolex_minutes_luminous": 17,
                                                       "Rolex_minutes_write": 17,
                                                       "Hermes_seconds": 27,
                                                       "Hermes_seconds_orange": 27,
                                                       "Nike_seconds": 26,
                                                       "Nike_seconds_orange": 26,
                                                       "Rolex_seconds_gold": 67,
                                                       "Rolex_seconds_luminous": 67,
                                                       "Rolex_seconds_write": 67]
    private var watchResList: [WatchRes] = []

    func getHandAnchorPoint(_ name: String) -> CGFloat {
        let index = self.HandAnchorPoints.index(forKey: name)
        if (index != nil) {
            return self.HandAnchorPoints.values[index!]
        }
        return 0
    }

    private func addToRes(category: String, list: [String], append: String = "") {
        let res = WatchRes()
        res.category = category
        res.list = list
        if (append != "") {
            res.list.insert(append, at: 0)
        }

        self.watchResList.append(res)
    }

    private func loadImageNamesFromAsset() {
        if let path = Bundle.main.path(forResource: "watchimage", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                let faces = json["faces"] as! [String]

                self.addToRes(category: "faces", list: faces)
                self.addToRes(category: "hours", list: json["hours"] as! [String])
                self.addToRes(category: "minutes", list: json["minutes"] as! [String])
                self.addToRes(category: "seconds", list: json["seconds"] as! [String])
                self.addToRes(category: "logos", list: json["logos"] as! [String])
                self.addToRes(category: "infoback", list: json["infoback"] as! [String])
            }
            catch let error {
                print("res error")
                print(error)
            }
        }
    }


    func getImages(category: String) -> [String] {
        for res in self.watchResList {
            if (res.category == category) {
                return res.list
            }
        }
        return []
    }

    static var Faces: String = "faces"
    static var Hours: String = "hours"
    static var Minutes: String = "minutes"
    static var Seconds: String = "seconds"
    static var Logos: String = "logos"
    static var Infoback: String = "infoback"



}
