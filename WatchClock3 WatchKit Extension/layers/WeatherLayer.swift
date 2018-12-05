//
//  WeatherLayer.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/3.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import SpriteKit


enum WeatherContentStyle : Int,Codable {
    case WeatherContentTemp, WeatherContentType, WeatherContentAQI, WeatherContentPM25, WeatherContentPM10
    case WeatherContentHigh, WeatherContentLow, WeatherContentHumidity, WeatherContentWindPower, WeatherContentWindDirection
}

class WeatherLayer : TextLayer {
    override func getTag() -> Int {
        return 7
    }
    
    override func getTitle() -> String {
        return "Weather"
    }
    
    
    private var weatherData : CnWeatherData?
    
    var showTempUnit : Bool = true
    
    override func getText() -> String {
        if (weatherData == nil) {
            return ""
        }
        
        switch self.weatherContent {
        case .WeatherContentTemp:
            if self.showTempUnit {
                return weatherData!.Wendu + "℃"
            }
            return weatherData!.Wendu
        case .WeatherContentType:
            return weatherData!.type
        case .WeatherContentAQI:
            return weatherData!.aqi
        case .WeatherContentPM25:
            return weatherData!.pm25
        case .WeatherContentPM10:
            return weatherData!.pm10
        case .WeatherContentHigh:
            if self.showTempUnit {
                return weatherData!.high + "℃"
            }
            return weatherData!.high
        case .WeatherContentLow:
            if self.showTempUnit {
                return weatherData!.low + "℃"
            }
            return weatherData!.low
        case .WeatherContentHumidity:
            return weatherData!.shidu
        case .WeatherContentWindPower:
            return weatherData!.fengli
        case .WeatherContentWindDirection:
            return weatherData!.fengxiang
        }
    }

    func getAQIColor(_ aqi: Float) -> UIColor {
        if (aqi < 50) {
            return UIColor.green
        }
        if (aqi < 100) {
            return UIColor.yellow
        }
        if (aqi < 200) {
            return UIColor.orange
        }
        return UIColor.red
        
    }

    
    override func getImage() -> UIImage? {
        var img: UIImage?
        
        var size: CGSize?
        
        if (self.backImage != "" && self.backImage != "empty") {
            img = UIImage.init(named: self.backImage)
        }
        
        var weatherImg: UIImage?
        
        if (self.showWeatherIcon && self.weatherData != nil) {
            let weatherIconName = "white_" + weatherData!.getWeatherCode()
            weatherImg = UIImage.init(named: weatherIconName)
        }
        
        self.oldText = self.getText()
        let text = NSString(string: oldText)
        
        var font: UIFont
        
        if (self.fontName == "") {
            font = UIFont.systemFont(ofSize: self.fontSize)
        } else {
            font = UIFont.init(name: self.fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        }
        
        let text_style = NSMutableParagraphStyle()
        text_style.alignment = NSTextAlignment.center
        
        var tmpTextColor = textColor.Color
        
        if ((weatherData != nil) && self.showColorAQI) {
            switch self.weatherContent {
            case .WeatherContentAQI:
                tmpTextColor = self.getAQIColor(NumberFormatter().number(from: weatherData!.aqi)?.floatValue ?? 0)
                break
            case .WeatherContentPM25:
                tmpTextColor = self.getAQIColor(NumberFormatter().number(from: weatherData!.pm25)?.floatValue ?? 0)
                break
            case .WeatherContentPM10:
                tmpTextColor = self.getAQIColor(NumberFormatter().number(from: weatherData!.pm10)?.floatValue ?? 0)
                break
            default:
                break
            }
        }
        
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: text_style, NSAttributedString.Key.foregroundColor: tmpTextColor]
        
        let rect = text.boundingRect(with: CGSize(width: 500, height: 500), options: [], attributes: attributes, context: nil)
        if (size == nil) {
            size = CGSize(width: rect.width, height: rect.height)
            
            if (size?.width == 0 || size?.height == 0) {
                size = CGSize(width: 10, height: 10)
            }
            
            if (weatherImg != nil) {
                size!.width = size!.width + weatherIconSize
                
                if (size!.height < weatherIconSize) {
                    size!.height = weatherIconSize
                }
            }
            
            if (img != nil) {
                size = CGSize.init(width: size!.width + 20, height: size!.height + 10)
            }
        } else if (weatherImg != nil) {
            if (size!.width < weatherIconSize + rect.width) {
                size!.width = weatherIconSize + rect.width
            }
            if (size!.height < max(weatherIconSize, rect.height)) {
                size!.height = max(weatherIconSize, rect.height)
            }
        }
        
        UIGraphicsBeginImageContext(size!)
        
        let context = UIGraphicsGetCurrentContext()
        
        if (img != nil) {
            img?.draw(in: CGRect(origin: CGPoint.zero, size: size!))
        } else {
            context?.setFillColor(UIColor.clear.cgColor)
            context?.fill(CGRect.init(x: 0, y: 0, width: size!.width, height: size!.height))
        }
        
        //vertically center (depending on font)
        let text_h = font.lineHeight
        let text_y = (size!.height - text_h) / 2
        var text_rect = CGRect(x: 0, y: text_y, width: size!.width, height: text_h)
        
        if (weatherImg != nil) {
            let tmpy = (size!.height - self.weatherIconSize) / 2
            let tmpx = (size!.width - weatherIconSize - rect.width) / 2
            let weatherRect = CGRect(x: tmpx, y: tmpy, width: weatherIconSize, height: weatherIconSize)
            weatherImg?.draw(in: weatherRect)
            text_rect = CGRect(x: tmpx + weatherIconSize, y: text_y, width: size!.width - weatherIconSize - 2 * tmpx, height: text_h)
        }
        
        text.draw(in: text_rect.integral, withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image

    }
    
    var showWeatherIcon : Bool = false
    var weatherContent : WeatherContentStyle = .WeatherContentTemp
    var showColorAQI : Bool = true
    var weatherIconSize : CGFloat = 20

    private enum CodingKeys: String, CodingKey {
        case showWeatherIcon
        case weatherContent
        case showColorAQI
        case weatherIconSize
    }
    
    override init() {
        super.init()
        self.addWeatherListen()
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(showWeatherIcon, forKey: .showWeatherIcon)
        try container.encode(weatherContent, forKey: .weatherContent)
        try container.encode(showColorAQI, forKey: .showColorAQI)
        try container.encode(weatherIconSize, forKey: .weatherIconSize)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.showWeatherIcon = try container.decode(Bool.self, forKey: .showWeatherIcon)
        self.weatherContent = try container.decode(WeatherContentStyle.self, forKey: .weatherContent)
        self.showColorAQI = try container.decode(Bool.self, forKey: .showColorAQI)
        self.weatherIconSize = try container.decode(CGFloat.self, forKey: .weatherIconSize)
        self.addWeatherListen()
    }
    
    private func addWeatherListen() {
        NotificationCenter.default.addObserver(forName: Notification.Name("WeatherDataUpdate"), object: nil, queue: nil, using: setWeatherData)
        self.weatherData = ResManager.Manager.weatherData
        if (self.weatherData == nil) {
            ResManager.Manager.beginWeather()
        }
    }
    
    private func setWeatherData(notification: Notification) {
        self.weatherData = ResManager.Manager.weatherData
        self.changed = true
        print("weather data is recived")
    }
    
}
