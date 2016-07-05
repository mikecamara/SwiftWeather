//
//  WeeklyTableViewController.swift
//  Van Gogh
//
//  Created by Mike Camara on 19/10/2015.
//  Copyright © 2015 Mike Camara. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class WeeklyTableViewController: UITableViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
  
    let locationManager = CLLocationManager()
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var userLocation : String!
    var userLatitude : Double!
    var userLongitude : Double!
    
    
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    @IBOutlet weak var currentTemperatureRangeLabel: UILabel?
    @IBOutlet weak var currentLocationLabel: UILabel?
    
    private let forecastAPIKey = "d27540fae83b3983cab20efd226287e5"
    //let coordinate: (lat: Double, long: Double) = (31.9522, 115.8589)
    
       
    var weeklyWeather: [DailyWeather] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        retrieveWeatherForecast()
        
            
        
    }
    
    

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}


// MARK: - Location Delegate Methods
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        let location = locations.last
        
        
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as! CLLocation
            var coord = locationObj.coordinate
            
            
            print(coord.latitude)
            print(coord.longitude)
            
            self.userLatitude = coord.latitude
            self.userLongitude = coord.longitude
            
            print(userLocation)
            
            retrieveWeatherForecast()
        }

        
            self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors:" + error.localizedDescription)
    }
    
    func triggerLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            if self.locationManager.respondsToSelector("requestAlwaysAuthorization") {
                locationManager.requestAlwaysAuthorization()
            } else {
                startUpdatingLocation()
            }
        }
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    

    
        func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            switch CLLocationManager.authorizationStatus() {
            case .NotDetermined:
                manager.requestAlwaysAuthorization()
            case .Authorized:
                manager.startUpdatingLocation()
            case .AuthorizedWhenInUse, .Restricted, .Denied:
                let alertController = UIAlertController(
                    title: "Background Location Access Disabled",
                    message: "In order to see local weather data, please open this app's settings and set location access to 'Always'.",
                    preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                    if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                alertController.addAction(openAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
                
                
            }
    }



func configureView() {
    
    // Set table View's background view property
    tableView.backgroundView = BackgroundView()
    
    // Set custom height for table view row
    tableView.rowHeight = 64
    
    // Change the nav bar text
    let navBarAttributesDictionary:[String: AnyObject]? = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    
    navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
    
    refreshControl?.layer.zPosition = tableView.backgroundView!.layer.zPosition + 1
    refreshControl?.tintColor = UIColor.whiteColor()
}

    @IBAction func chageUnits() {
        retrieveWeatherForecastFar()
    }


@IBAction func refreshWeather() {
    retrieveWeatherForecast()
    refreshControl?.endRefreshing()
}


// MARK: - Navigation

override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDaily" {
        if let indexPath = tableView.indexPathForSelectedRow{
            let dailyWeather = weeklyWeather[indexPath.row]
            
            (segue.destinationViewController as! ViewController).dailyWeather = dailyWeather
        }
    }
}

// MARK: - Table view data source

override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // Return the number of sections
    return 1
}

override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Forecast"
}

override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Return the number of rows
    return weeklyWeather.count
}

override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell")! as! DailyWeatherTableViewCell
    
    let dailyWeather = weeklyWeather[indexPath.row]
    if let maxTemp = dailyWeather.maxTemperature {
        cell.temperatureLabel.text = "\(maxTemp)º"
    }
    cell.weatherIcon.image = dailyWeather.icon
    cell.dayLabel.text = dailyWeather.day
    
    return cell
}

// MARK: - Delegate Methods

override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    view.tintColor = UIColor(red: 170/255.0, green: 131/255.0, blue: 224/255.0, alpha: 1.0)
    
    if let header = view as? UITableViewHeaderFooterView {
        header.textLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
        header.textLabel!.textColor = UIColor.whiteColor()
    }
}

override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
    var cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.contentView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
    let highlightView = UIView()
    highlightView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
    cell?.selectedBackgroundView = highlightView
}

// MARK: - Weather Fetching

func retrieveWeatherForecast() {
    
    let lat = locationManager.location?.coordinate.latitude
    let lon = locationManager.location?.coordinate.longitude
    
    
    let forecastService = ForecastService(APIKey: forecastAPIKey)
    forecastService.getForecast(lat!,long: lon!) {
        
        
        
        (let forecast) in
        if let weatherForecast = forecast,
            
            let currentWeather = weatherForecast.currentWeather{
                
                dispatch_async(dispatch_get_main_queue()){
                    
                    if let temperature = currentWeather.temperature {
                        self.currentTemperatureLabel?.text = "\(temperature)º"
                    }
                    
                    if let location = weatherForecast.currentLocation{
                        self.currentLocationLabel?.text = "\(location)"
                    }
                    
                    if let precipitation = currentWeather.precipProbability {
                        self.currentPrecipitationLabel?.text = "Rain: \(precipitation)%"
                    }
                    
                    if let icon = currentWeather.icon {
                        self.currentWeatherIcon?.image = icon
                    }
                    
                    
                    
                    self.weeklyWeather = weatherForecast.weekly
                    
                    if let highTemp = self.weeklyWeather.first?.maxTemperature,
                        let lowTemp = self.weeklyWeather.first?.minTemperature {
                            self.currentTemperatureRangeLabel?.text = "↑\(highTemp)º↓\(lowTemp)º"
                    }
                    
                    self.tableView.reloadData()
                    
                }
        }
    }
}
    
    // Retrieve weather in farenheith
    func retrieveWeatherForecastFar() {
        
        let lat = locationManager.location?.coordinate.latitude
        let lon = locationManager.location?.coordinate.longitude
        
        
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        forecastService.getForecastFaren(lat!,long: lon!) {
            
            
            
            (let forecast) in
            if let weatherForecast = forecast,
                
                let currentWeather = weatherForecast.currentWeather{
                    
                    dispatch_async(dispatch_get_main_queue()){
                        
                        if let temperature = currentWeather.temperature {
                            self.currentTemperatureLabel?.text = "\(temperature)º"
                        }
                        
                        if let location = weatherForecast.currentLocation{
                            self.currentLocationLabel?.text = "\(location)"
                        }
                        
                        if let precipitation = currentWeather.precipProbability {
                            self.currentPrecipitationLabel?.text = "Rain: \(precipitation)%"
                        }
                        
                        if let icon = currentWeather.icon {
                            self.currentWeatherIcon?.image = icon
                        }
                        
                        
                        
                        self.weeklyWeather = weatherForecast.weekly
                        
                        if let highTemp = self.weeklyWeather.first?.maxTemperature,
                            let lowTemp = self.weeklyWeather.first?.minTemperature {
                                self.currentTemperatureRangeLabel?.text = "↑\(highTemp)º↓\(lowTemp)º"
                        }
                        
                        self.tableView.reloadData()
                        
                    }
            }
        }
    }
    
}
