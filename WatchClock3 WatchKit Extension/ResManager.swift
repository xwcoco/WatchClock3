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
                                                       "Rolex_seconds_white": 67]
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
                self.addToRes(category: "infoback", list: json["infoback"] as! [String], append: "empty")
                self.addToRes(category: "altitude", list: json["altitude"] as! [String])

                
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
    
    func WeatherLocationChanged(noti : Notification) -> Void {
        self.beginWeather()
    }


    static var Faces: String = "faces"
    static var Hours: String = "hours"
    static var Minutes: String = "minutes"
    static var Seconds: String = "seconds"
    static var Logos: String = "logos"
    static var Infoback: String = "infoback"
    static var altitudeBG : String = "altitude"


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
