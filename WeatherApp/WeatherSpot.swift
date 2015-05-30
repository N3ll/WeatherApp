//
//  WeatherSpot.swift
//  WeatherApp
//
//  Created by Nelly Chakarova on 28/05/15.
//  Copyright (c) 2015 Nelly Chakarova. All rights reserved.
//

import Foundation
import MapKit

var tempr:Double = 0

class WeatherSpot : NSObject, MKAnnotation {
    var title : String
    let coordinate :CLLocationCoordinate2D
    let temperature: Double
    let weatherDescription : String
    let imgURL: String
    
    
    init(title: String, coordinate: CLLocationCoordinate2D, temperature: Double, weatherDescription: String, imgURL: String){
        
        self.title = title
        self.coordinate = coordinate
        self.temperature = temperature
        self.weatherDescription = weatherDescription
        self.imgURL = imgURL
        super.init()
        
    }
    
    var subtitle: String{
        return String(format:"%.0f℃",temperature)
    }
    
    func toDictionary() -> [String:String]{
        var coordinates = String(format: "%g,%g",self.coordinate.latitude,self.coordinate.longitude)
        var temp = String(format:"%0.f℃", self.temperature)
        
        return ["title" : self.title,
                "coordinates":coordinates,
                "temperature":temp,
                "description":self.weatherDescription,
                "img":self.imgURL]
    }
    
}
//End of WeatherSpot.swift class