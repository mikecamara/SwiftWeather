//
//  NetworkOperation.swift
//  Van Gogh
//
//  Created by Mike Camara on 15/10/2015.
//  Copyright © 2015 Mike Camara. All rights reserved.
//

import Foundation

class NetworkOperation {
    
    lazy var config: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = NSURLSession(configuration: self.config)
    let queryURL: NSURL
    
    typealias JSONDictionaryCompletion = ([String: AnyObject]?) -> Void
    
    init(url: NSURL) {
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion: JSONDictionaryCompletion) {
        // Load URL
        let request = NSURLRequest(URL: queryURL)
        // Make URL request
        let dataTask = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            // 1. Check HTTP response for successful GET request
            if let httpResponse = response as? NSHTTPURLResponse {
                switch(httpResponse.statusCode) {
                case 200:
                    // 2. Create JSON Object with data
                    do {
                        let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! [String: AnyObject]
                        // Send data to closure
                        completion(jsonDictionary)
                    } catch {
                        print(error)
                    }
                    
                default:
                    print("GET request not successful. HTTP status code: \(httpResponse.statusCode). Url: \(httpResponse.URL)")
                    
                }
            } else {
                print("Error: Not a valid HTTP response")
            }
            
        }
        
        dataTask.resume()
    }
}