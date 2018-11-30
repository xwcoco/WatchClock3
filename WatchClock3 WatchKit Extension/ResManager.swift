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
    var category : String = ""
    var list : [String] = []
}

class ResManager : NSObject {
    static let Manager : ResManager = ResManager()
    
    private override init() {
        super.init()
        self.loadImageNamesFromAsset()
    }
    
    private var watchResList : [WatchRes] = []
    
    private func addToRes(category : String,list : [String],append : String = "") {
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
                let json = try JSONSerialization.jsonObject(with: data) as! [String:Any]
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
    
    func getImages(category : String) -> [String] {
        for res in self.watchResList {
            if (res.category == category) {
                return res.list
            }
        }
        return []
    }
    
    static var Faces : String = "faces"
    static var Hours : String = "hours"
    static var Minutes : String = "minutes"
    static var Seconds : String = "seconds"
    static var Logos : String = "logos"
    static var Infoback : String = "infoback"
    

    
}
