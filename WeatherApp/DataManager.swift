//
//  DataManager.swift
//  WeatherApp
//
//  Created by Nelly Chakarova on 28/05/15.
//  Copyright (c) 2015 Nelly Chakarova. All rights reserved.
//


import Foundation
import CoreLocation

var weatherURL = "http://api.wunderground.com/api/3e2694341b7e65f2/conditions/q/"


class DataManager {
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
//        println("loadDataFromURL")
        println("\(url)")
        var session = NSURLSession.sharedSession()
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError()
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
    
    class func getWeatherInfoFromCoordinatesWithSuccess(coordinates:CLLocationCoordinate2D, success:((weatherData: NSData!) -> Void)){
//         println("getWeatherInfo")
        var latitute : String = String(format: "%g", coordinates.latitude)
        var longitude : String = String(format: "%g", coordinates.longitude)
        
//                println("\(latitute)")
//                println("\(longitude)")
        
        var originaURL = weatherURL
        weatherURL = weatherURL + latitute + ","+longitude + ".json"
        
        //         println("\(weatherURL)")
        
        loadDataFromURL(NSURL(string: weatherURL)!, completion: {(data,error) -> Void in
            if let urlData = data {
                success(weatherData: urlData)
            }
        })
        
        weatherURL = originaURL
    }
}

//End of DataManager.swift class