//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nelly Chakarova on 28/05/15.
//  Copyright (c) 2015 Nelly Chakarova. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


let userDefaults = NSUserDefaults.standardUserDefaults()
var keys = [String]()

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherMap: MKMapView! {
        didSet {
            var pressToPin = UILongPressGestureRecognizer(target: self, action: "pinWeatherLocation:")
            pressToPin.minimumPressDuration = 1.0
            weatherMap.addGestureRecognizer(pressToPin)
        }
    }
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
//                let appDomain = NSBundle.mainBundle().bundleIdentifier
//                userDefaults.removePersistentDomainForName(appDomain!)
        
        super.viewDidLoad()
        weatherMap.mapType = MKMapType.Hybrid
        
        weatherMap.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        weatherMap.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if let haveKeys: AnyObject = userDefaults.objectForKey("keys"){
                        println("\(haveKeys)")
            keys = userDefaults.objectForKey("keys") as! Array<String>
        }
        
        ViewController.updateWeatherInfo()
    }
    
    class func updateWeatherInfo(){
        for key in keys {
            var tempDict : [String:String] = userDefaults.dictionaryForKey(key) as! Dictionary<String,String>
            var title = tempDict["title"]
            var coordinates = tempDict["coordinates"]
            var latitudeString = coordinates?.componentsSeparatedByString(",")[0]
            var latitude = NSNumberFormatter().numberFromString(latitudeString!)?.doubleValue
            
            var longitudeString = coordinates?.componentsSeparatedByString(",")[1]
            var longitude = NSNumberFormatter().numberFromString(longitudeString!)?.doubleValue
            
            let coord2D = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            
            DataManager.getWeatherInfoFromCoordinatesWithSuccess(coord2D){(weatherData) -> Void in
                println("\(coord2D.latitude)")
                println("\(coord2D.longitude)")
                
                let json = JSON(data: weatherData)
                //            println("\(json)")
                
                var tempr:Double = 0
                if let temperature = json["current_observation"]["temp_c"].double {
                    tempr = temperature
                }
                //            println("\(tempr)")
                var weatherDescription = json["current_observation"]["weather"].string!
                //            println("\(weatherDescription)")
                var imgURL = json["current_observation"]["icon_url"].string!
                //            println("\(imgURL)")
                
                var weatherSpot = WeatherSpot(title: title!, coordinate: coord2D, temperature: tempr, weatherDescription: weatherDescription, imgURL: imgURL)
                
               ViewController.addSpotToNSUserDefaults(weatherSpot)
            }
        }
    }
    
    func pinWeatherLocation(gesture:UIGestureRecognizer){
        println("Pin weather")
        if gesture.state != .Began {return}
        let pressedLocation = gesture.locationInView(self.weatherMap)
        let pressedCoordinates = weatherMap.convertPoint(pressedLocation, toCoordinateFromView: weatherMap)
        let location = CLLocation(latitude: pressedCoordinates.latitude, longitude: pressedCoordinates.longitude)
        
        DataManager.getWeatherInfoFromCoordinatesWithSuccess(pressedCoordinates){(weatherData) -> Void in
            //            println("\(pressedCoordinates.latitude)")
            //            println("\(pressedCoordinates.longitude)")
            
            let json = JSON(data: weatherData)
            //            println("\(json)")
            
            var tempr:Double = 0
            if let temperature = json["current_observation"]["temp_c"].double {
                tempr = temperature
            }
            //            println("\(tempr)")
            var weatherDescription = json["current_observation"]["weather"].string!
            //            println("\(weatherDescription)")
            var imgURL = json["current_observation"]["icon_url"].string!
            //            println("\(imgURL)")
            
            var weatherSpot = WeatherSpot(title: "Hello", coordinate: pressedCoordinates, temperature: tempr, weatherDescription: weatherDescription, imgURL: imgURL)
            
            self.askForName(weatherSpot)
            
            self.weatherMap.addAnnotation(weatherSpot)
            self.putLocationInCenter(location)
        }
    }
    
    
    func askForName (weatherSpot: WeatherSpot){
        var alert = UIAlertController(title: "Pin Title", message: "Please give a name to your location :)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "You shall be named..."
        })
        alert.addAction(UIAlertAction(title: "Name It", style: UIAlertActionStyle.Default, handler: {(action) -> Void in
            let textField = alert.textFields![0] as! UITextField
            weatherSpot.title = textField.text
            ViewController.addSpotToNSUserDefaults(weatherSpot)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func addSpotToNSUserDefaults(weatherSpot: WeatherSpot){
        var toDictionary = weatherSpot.toDictionary()
        var coordinates = String(format: "%g,%g",weatherSpot.coordinate.latitude,weatherSpot.coordinate.longitude)
        userDefaults.setObject(toDictionary, forKey: coordinates)
        if !contains(keys, coordinates){
            keys.append(coordinates)
        }
    }
    
    let regionRadius: CLLocationDistance = 1000
    func putLocationInCenter(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        weatherMap.setRegion(coordinateRegion,animated:true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showLocations"){
            var locations = segue.destinationViewController as? LocationsTableViewController
            locations?.keys = keys
            //            println("\(keys)")
        }
    }
    
    class func saveKeys(){
        userDefaults.setObject(keys, forKey: "keys")
        
    }
}

//End of ViewController.swift class


