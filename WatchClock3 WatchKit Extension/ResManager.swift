//
//  ResManager.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/29.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class WatchRes {
    var category: String = ""
    var list: [String] = []
}

class ResManager: NSObject, CnWeatherProtocol, CLLocationManagerDelegate {

    static let Manager: ResManager = ResManager()

    private override init() {
        super.init()
        self.loadImageNamesFromAsset()

        NotificationCenter.default.addObserver(forName: Notification.Name("WeatherLocationChanged"), object: nil, queue: nil, using: WeatherLocationChanged)


    }

    private var HandAnchorPoints: [String: CGFloat] = ["Hermes_minutes": 17,
                                                       "Hermes_hours": 22,
                                                       "Hermes_hours_white": 23,
                                                       "HermesDoubleclour_H": 14,
                                                       "HermesDoubleclour_H_Orange": 14,
                                                       "HermesDoubleclour_H_Pink": 15,
                                                       "Nike_hours": 15,
                                                       "Nike_hours_red": 14,
                                                       "Rolex_hours_gold": 21,
                                                       "Rolex_hours_luminous": 25,
                                                       "Rolex_hours_white": 24,
                                                       "Hermes_minutes_white": 18,
                                                       "HermesDoubleclour_M": 16,
                                                       "HermesDoubleclour_M_Orange": 16,
                                                       "HermesDoubleclour_M_Pink": 16,
                                                       "valour_hour": 35,
                                                       "Nike_minutes": 18,
                                                       "Nike_minutes_red": 18,
                                                       "Rolex_minutes_gold": 18,
                                                       "Rolex_minutes_luminous": 18,
                                                       "Rolex_minutes_white": 17,
                                                       "valour_minute" : 38,
                                                       "Hermes_seconds": 27,
                                                       "Hermes_seconds_orange": 26,
                                                       "Nike_seconds": 26,
                                                       "Nike_seconds_orange": 26,
                                                       "Rolex_seconds_gold": 69,
                                                       "Rolex_seconds_luminous": 67,
                                                       "Rolex_seconds_white": 69,
                                                       "valour_second" : 49,
                                                       "info_date_pointer1" : 21,
                                                       "clown_hour" : 70,
                                                       "clown_minute" : 70]
    private var watchResList: [WatchRes] = []

    private var infoBackEdgeInsets: [String: UIEdgeInsets] = ["infoback1": UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10),
                                                              "infoback2": UIEdgeInsets.init(top: 7, left: 7, bottom: 7, right: 7),
                                                              "infoback5": UIEdgeInsets.init(top: 22, left: 22, bottom: 22, right: 22),
                                                              "infoback6": UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15),
                                                              "info_back_3": UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)]
    
    private var infoBackNoTintColor : [String] = ["infoback5","infoback6"]
    
    func getInfoBackCanTingColor(_ name : String) -> Bool {
        let index = self.infoBackNoTintColor.firstIndex(of: name)
        if (index != nil) {
            return false
        }
        return true
    }

    func getInfoBackEdgeInsets(_ name: String) -> UIEdgeInsets? {
        let index = self.infoBackEdgeInsets.index(forKey: name)
        if (index != nil) {
            return self.infoBackEdgeInsets.values[index!]
        }
        return nil
    }

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
                self.addToRes(category: "infoback", list: json["infoback"] as! [String], append: "empty")
                self.addToRes(category: "altitude", list: json["altitude"] as! [String])
                
                self.addToRes(category: "infodateback", list: json["infodateback"] as! [String], append: "empty")
                self.addToRes(category: "infodatepointer", list: json["infodatepointer"] as! [String])
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

//    var WeatherLocation: String = "101180101"

    lazy var cnWeather: CnWeather = CnWeather()
    func beginWeather() -> Void {
        self.cnWeather.delegate = self
        self.cnWeather.beginTimer()
    }

    var weatherData: CnWeatherData?
    func showWeather(_ data: CnWeatherData) {
        self.weatherData = data
        NotificationCenter.default.post(name: Notification.Name("WeatherDataUpdate"), object: self)
    }

    func WeatherLocationChanged(noti: Notification) -> Void {
        self.beginWeather()
    }


    static var Faces: String = "faces"
    static var Hours: String = "hours"
    static var Minutes: String = "minutes"
    static var Seconds: String = "seconds"
    static var Logos: String = "logos"
    static var Infoback: String = "infoback"
    static var altitudeBG: String = "altitude"
    static var InfoDatePointer : String = "infodatepointer"
    static var InfoDateBack : String = "infodateback"
    
    static var EMPTY : String = "empty"


    var locationManager: CLLocationManager?

    func initLocationManager() -> Void {
        if (locationManager == nil) {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.distanceFilter = 100
            locationManager?.requestAlwaysAuthorization()
        }
    }

    func initLocation() {
        self.initLocationManager()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager?.startUpdatingLocation()
        }

    }

//    func initLocationHeading() -> Void {
//        self.initLocationManager()
//        if (CLLocationManager.headingAvailable()) {
//            locationManager?.startUpdatingHeading()
//        }
//    }

    var location: CLLocation?
//    var locationHeading: CLHeading?

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("update location....")
        if let curLocation = locations.last {
            self.location = curLocation
            print("get location")
            NotificationCenter.default.post(name: Notification.Name("LocationUpdate"), object: self)

//            print(curLocation.coordinate)
//
//            //            +34.82552014,+113.63304707
//
//            if (self.currentAltitude != curLocation.altitude) {
//                self.currentAltitude = curLocation.altitude
//                print(curLocation)
//                self.delegate?.UpdateWatchInfo(refresh: false)
//            }
//
//            if curLocation.horizontalAccuracy < 0 { return }
//            geoCoder.reverseGeocodeLocation(curLocation, completionHandler: self.locationCompletion)

        }
    }

//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        self.locationHeading = newHeading
//        NotificationCenter.default.post(name: Notification.Name("LocationHeadingUpdate"), object: self)
//    }

//    func locationCompletion(pls: [CLPlacemark]?, error: Error?) -> Void {
//        if error == nil {
//            guard let pl = pls?.first else { return }
//            print(pl.name!)
//            print(pl.locality!)
//        } else {
//            print(error)
//        }
//    }




}
