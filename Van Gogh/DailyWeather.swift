//
//  DailyWeather.swift
//  Van Gogh
//
//  Created by Mike Camara on 21/10/2015.
//  Copyright © 2015 Mike Camara. All rights reserved.
//

import Foundation
import UIKit

struct DailyWeather {
    
    let maxTemperature: Int?
    let minTemperature: Int?
    let humidity: Int?
    let precipChance: Int?
    let summary: String?
    var icon: UIImage? = UIImage(named: "default.png")
    var largeIcon: UIImage? = UIImage(named: "default_large.png")
    var sunriseTime: String?
    var sunsetTime: String?
    var day: String?
    let dateFormatter = NSDateFormatter()
    
    init(dailyWeatherDict: [String: AnyObject]) {
        
        maxTemperature = dailyWeatherDict["temperatureMax"] as? Int
        minTemperature = dailyWeatherDict["temperatureMin"] as? Int

        if let humidityFloat = dailyWeatherDict["humidity"] as? Double {
            
            humidity = Int(humidityFloat * 100)
            
        } else {
            
            humidity = nil
            
        }
        if let precipChanceFloat = dailyWeatherDict["precipProbability"] as? Double {
            
            precipChance = Int(precipChanceFloat * 100)
            
        } else {
            
            precipChance = nil
            
        }
        
        summary = dailyWeatherDict["summary"] as? String
        if let iconString = dailyWeatherDict["icon"] as? String,
            let iconEnum = Icon(rawValue: iconString) {
                (icon, largeIcon) = iconEnum.toImage()
        }
        if let sunriseDate = dailyWeatherDict["sunriseTime"] as? Double {
            sunriseTime = timeStringFromUnixTime(sunriseDate)
        } else {
            sunriseTime = nil
        }
        if let sunsetDate = dailyWeatherDict["sunsetTime"] as? Double {
            sunsetTime = timeStringFromUnixTime(sunsetDate)
        } else {
            sunsetTime = nil
        }
        if let time = dailyWeatherDict["time"] as? Double {
            day = dayStringFromTime(time)
        }
    }

    
        
        func timeStringFromUnixTime(unixTime: Double) -> String {
        
        let date = NSDate(timeIntervalSince1970: unixTime)
            
            // Returns date formatted as 12 hour time.
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter.stringFromDate(date)
    }
    
    func dayStringFromTime(time: Double) -> String {
        let date = NSDate(timeIntervalSince1970: time)
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(date)
    }
}







