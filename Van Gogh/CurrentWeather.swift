//
//  CurrentWeather.swift
//  Van Gogh
//
//  Created by Mike Camara on 14/10/2015.
//  Copyright © 2015 Mike Camara. All rights reserved.
//

import Foundation
import UIKit


struct CurrentWeather {
    
    let temperature: Int?
    let humidity: Int?
    let precipProbability: Int?
    let summary: String?
    var icon: UIImage? = UIImage(named:"default.png")
    
    init(weatherDictionary: [String: AnyObject]) {
        
        temperature = weatherDictionary["temperature"] as? Int
        
        if let humidityFloat = weatherDictionary["humidity"] as? Double{
            humidity = Int(humidityFloat * 100)
        } else {
            humidity = nil
        }
        
        if let precipFloat = weatherDictionary["precipProbability"] as?  Double{
            precipProbability = Int(precipFloat * 100)
        } else {
            precipProbability = nil
        }
        
        summary = weatherDictionary["summary"] as? String
        
        if let iconString = weatherDictionary["icon"] as? String,
            let weatherIcon: Icon = Icon(rawValue: iconString){
                (icon, _) = weatherIcon.toImage()
        }
    }
}


