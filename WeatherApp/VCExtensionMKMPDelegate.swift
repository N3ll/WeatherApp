//
//  VCExtensionMKMPDelegate.swift
//  WeatherApp
//
//  Created by Nelly Chakarova on 28/05/15.
//  Copyright (c) 2015 Nelly Chakarova. All rights reserved.
//

import Foundation
import MapKit

extension ViewController: MKMapViewDelegate{
    
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
//        println("\(weatherMap.userLocation.location)")
//        println("\(mapView.userLocation.coordinate.latitude)")
//        println("\(mapView.userLocation.coordinate.longitude)")
        
        if (weatherMap.userLocation.location) != nil{
            
            putLocationInCenter(mapView.userLocation.location)
           
            
            DataManager.getWeatherInfoFromCoordinatesWithSuccess(weatherMap.userLocation.coordinate){(weatherData) -> Void in
                var json = JSON(data: weatherData)
//                println("\(json)")
                
                var tempr:Double = 0
                if let temperature = json["current_observation"]["temp_c"].double {
                    tempr = temperature
                }
//                println("\(tempr)")
                
                var weatherDescription = json["current_observation"]["weather"].string!
//                println("\(weatherDescription)")
                
                var imgURL = json["current_observation"]["icon_url"].string!
//                println("\(imgURL)")
                
                var weatherSpot = WeatherSpot(title: "I am here", coordinate: self.weatherMap.userLocation.coordinate, temperature: tempr, weatherDescription: weatherDescription, imgURL: imgURL)
                
                self.askForName(weatherSpot)
                self.weatherMap.addAnnotation(weatherSpot)
            }
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? WeatherSpot {
            let identifier = "pin"
            
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }else{
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint (x: -5, y:5)
            }
            view.pinColor = .Purple
            return view
        }
        return nil
    }
}
//End of VCExtensionMKMPDelegate.swift class
