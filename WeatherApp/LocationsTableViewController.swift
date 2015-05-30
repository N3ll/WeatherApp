//
//  LocationsTableViewController.swift
//  WeatherApp
//
//  Created by Nelly Chakarova on 29/05/15.
//  Copyright (c) 2015 Nelly Chakarova. All rights reserved.
//

import UIKit

class LocationsTableViewController: UITableViewController {
    
    var locations = [Dictionary<String,String>]()
    var keys = [String]()
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //         println("\(keys)")
        self.loadData()
        
    }
    
    func loadData(){
        locations = [Dictionary<String,String>]()
        for key in keys {
            var tempDict : [String:String] = userDefaults.dictionaryForKey(key) as! Dictionary<String,String>
            locations.append(tempDict)
        }
    }
    
    @IBAction func updateData(sender: UIBarButtonItem) {
        ViewController.updateWeatherInfo()
        loadData()
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locations.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("location", forIndexPath: indexPath) as! UITableViewCell
        
        var title = cell.viewWithTag(1) as! UILabel
        var coordinates = cell.viewWithTag(2) as! UILabel
        var temperature = cell.viewWithTag(3) as! UILabel
        var description = cell.viewWithTag(4) as! UILabel
        var img = cell.viewWithTag(5) as! UIImageView
        
        
        var weatherSpot = locations[indexPath.row]
        
        title.text = weatherSpot["title"]
        coordinates.text = weatherSpot["coordinates"]
        temperature.text = weatherSpot["temperature"]!
        description.text = weatherSpot["description"]
        
        
        if let weatherImg = weatherSpot["img"]{
            let imgURL = NSURL(string: weatherImg)!
            let data = NSData(contentsOfURL: imgURL)
            img.image = UIImage(data: data!)
        } else {
           
            img.image = UIImage(named : "deadSun")
        }
        
        
        
        
        return cell
    }
}
//End of LocationsTableViewController.swift class
