//
//  ForecastService.swift
//  Van Gogh
//
//  Created by Mike Camara on 15/10/2015.
//  Copyright © 2015 Mike Camara. All rights reserved.
//

import Foundation


struct ForecastService {

    let forecastAPIKey: String
    let forecastBaseURL: NSURL?
 
    init(APIKey: String) {
    
        forecastAPIKey = APIKey
        forecastBaseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
    }
    
    func getForecast(lat: Double, long: Double, completion: (Forecast? -> Void)) {
        if let forecastURL = NSURL(string: "\(lat),\(long)?units=si", relativeToURL: forecastBaseURL) {
            
            let networkOperation = NetworkOperation(url: forecastURL)
            
            networkOperation.downloadJSONFromURL {
                (let JSONDictionary) in
                let forecast = Forecast(weatherDictionary: JSONDictionary)
                completion(forecast)
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
    func getForecastFaren(lat: Double, long: Double, completion: (Forecast? -> Void)) {
        if let forecastURL = NSURL(string: "\(lat),\(long)", relativeToURL: forecastBaseURL) {
            
            let networkOperation = NetworkOperation(url: forecastURL)
            
            networkOperation.downloadJSONFromURL {
                (let JSONDictionary) in
                let forecast = Forecast(weatherDictionary: JSONDictionary)
                completion(forecast)
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
    
}