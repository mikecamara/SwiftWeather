//
//  Forecast.swift
//  Van Gogh
//
//  Created by Mike Camara on 22/10/2015.
//  Copyright © 2015 Mike Camara. All rights reserved.
//

import Foundation

struct Forecast {
    
    var currentWeather: CurrentWeather?
    var weekly: [DailyWeather] = []
    var currentLocation: String?
    
    init(weatherDictionary: [String: AnyObject]?) {
        
        currentLocation = weatherDictionary?["timezone"] as? String!
        
        if let currentWeatherDictionary = weatherDictionary?["currently"] as? [String: AnyObject] {
            currentWeather = CurrentWeather(weatherDictionary: currentWeatherDictionary)
            
        }
        
        if let weeklyWeatherArray = weatherDictionary?["daily"]?["data"] as? [[String: AnyObject]] {
            
            for dailyWeather in weeklyWeatherArray {
                let daily = DailyWeather(dailyWeatherDict: dailyWeather)
                weekly.append(daily)
            }
        }
        
    }
}
